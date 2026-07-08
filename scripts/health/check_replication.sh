#!/usr/bin/env bash

# check_replication.sh
# Purpose:
#   Check PostgreSQL streaming replication health for the DBA lab.
#
# Intended run location:
#   db-ops
#
# Checks performed:
#   1. db-primary is not in recovery mode
#   2. db-replica is in recovery mode
#   3. db-primary sees at least one streaming replica
#   4. db-replica WAL receiver is streaming
#   5. Active heartbeat insert on db-primary appears on db-replica
#   6. Replay delay is reported
#
# Notes:
#   This script prompts for the dbadmin PostgreSQL password once.
#   Later, for cron automation, this should be replaced with a secure .pgpass setup.

set -u

DB_NAME="dba_lab"
DB_USER="dbadmin"
DB_PRIMARY_HOST="10.0.0.129"
DB_REPLICA_HOST="10.0.0.153"

OVERALL_STATUS="OK"

set_warning() {
    if [ "$OVERALL_STATUS" = "OK" ]; then
        OVERALL_STATUS="WARNING"
    fi
}

set_critical() {
    OVERALL_STATUS="CRITICAL"
}

run_psql() {
    local host="$1"
    local sql="$2"

    psql \
        -q \
        -P pager=off \
        -v ON_ERROR_STOP=1 \
        -h "$host" \
        -U "$DB_USER" \
        -d "$DB_NAME" \
        -t \
        -A \
        -c "$sql"
}

echo "PostgreSQL DBA Lab Replication Health Check"
echo "Generated at: $(date)"
echo ""

read -rsp "PostgreSQL password for ${DB_USER}: " PGPASSWORD
echo ""
export PGPASSWORD
trap 'unset PGPASSWORD' EXIT

echo ""
echo "1. Checking primary recovery status..."

PRIMARY_IN_RECOVERY="$(run_psql "$DB_PRIMARY_HOST" "SELECT pg_is_in_recovery();" 2>/tmp/check_replication_primary_recovery.err)" || {
    echo "CRITICAL: Could not query db-primary recovery status."
    cat /tmp/check_replication_primary_recovery.err
    set_critical
    PRIMARY_IN_RECOVERY="unknown"
}

if [ "$PRIMARY_IN_RECOVERY" = "f" ]; then
    echo "OK: db-primary is not in recovery mode."
else
    echo "CRITICAL: db-primary recovery status is unexpected: ${PRIMARY_IN_RECOVERY}"
    set_critical
fi

echo ""
echo "2. Checking replica recovery status..."

REPLICA_IN_RECOVERY="$(run_psql "$DB_REPLICA_HOST" "SELECT pg_is_in_recovery();" 2>/tmp/check_replication_replica_recovery.err)" || {
    echo "CRITICAL: Could not query db-replica recovery status."
    cat /tmp/check_replication_replica_recovery.err
    set_critical
    REPLICA_IN_RECOVERY="unknown"
}

if [ "$REPLICA_IN_RECOVERY" = "t" ]; then
    echo "OK: db-replica is in recovery mode."
else
    echo "CRITICAL: db-replica is not in recovery mode. Result: ${REPLICA_IN_RECOVERY}"
    set_critical
fi

echo ""
echo "3. Checking primary-side replication status..."

PRIMARY_STREAMING_COUNT="$(run_psql "$DB_PRIMARY_HOST" "SELECT COUNT(*) FROM pg_stat_replication WHERE state = 'streaming';" 2>/tmp/check_replication_primary_state.err)" || {
    echo "CRITICAL: Could not query pg_stat_replication on db-primary."
    cat /tmp/check_replication_primary_state.err
    set_critical
    PRIMARY_STREAMING_COUNT="0"
}

if [ "$PRIMARY_STREAMING_COUNT" -ge 1 ]; then
    echo "OK: db-primary sees ${PRIMARY_STREAMING_COUNT} streaming replica connection(s)."
    echo "Primary-side replication details:"
    run_psql "$DB_PRIMARY_HOST" "SELECT client_addr, state, sync_state, COALESCE(write_lag::text, '') AS write_lag, COALESCE(flush_lag::text, '') AS flush_lag, COALESCE(replay_lag::text, '') AS replay_lag FROM pg_stat_replication;"
else
    echo "CRITICAL: db-primary does not show any streaming replica connections."
    set_critical
fi

echo ""
echo "4. Checking replica-side WAL receiver status..."

REPLICA_WAL_RECEIVER_STATUS="$(run_psql "$DB_REPLICA_HOST" "SELECT COALESCE((SELECT status FROM pg_stat_wal_receiver LIMIT 1), 'missing');" 2>/tmp/check_replication_wal_receiver.err)" || {
    echo "CRITICAL: Could not query pg_stat_wal_receiver on db-replica."
    cat /tmp/check_replication_wal_receiver.err
    set_critical
    REPLICA_WAL_RECEIVER_STATUS="unknown"
}

if [ "$REPLICA_WAL_RECEIVER_STATUS" = "streaming" ]; then
    echo "OK: db-replica WAL receiver is streaming."
    echo "Replica-side WAL receiver details:"
    run_psql "$DB_REPLICA_HOST" "SELECT status, sender_host, sender_port, latest_end_lsn, latest_end_time FROM pg_stat_wal_receiver;"
else
    echo "CRITICAL: db-replica WAL receiver is not streaming. Status: ${REPLICA_WAL_RECEIVER_STATUS}"
    set_critical
fi

echo ""
echo "5. Performing active heartbeat replication test..."

HEARTBEAT_ID="$(run_psql "$DB_PRIMARY_HOST" "WITH inserted AS (INSERT INTO lab_admin.replication_heartbeat (source_server, note) VALUES ('db-primary', 'automated replication health check from db-ops') RETURNING heartbeat_id) SELECT heartbeat_id FROM inserted;" 2>/tmp/check_replication_heartbeat_insert.err)" || {
    echo "CRITICAL: Could not insert heartbeat row on db-primary."
    cat /tmp/check_replication_heartbeat_insert.err
    set_critical
    HEARTBEAT_ID=""
}

if [ -n "$HEARTBEAT_ID" ]; then
    echo "Inserted heartbeat_id ${HEARTBEAT_ID} on db-primary."
    sleep 3

    HEARTBEAT_COUNT="$(run_psql "$DB_REPLICA_HOST" "SELECT COUNT(*) FROM lab_admin.replication_heartbeat WHERE heartbeat_id = ${HEARTBEAT_ID};" 2>/tmp/check_replication_heartbeat_replica.err)" || {
        echo "CRITICAL: Could not verify heartbeat row on db-replica."
        cat /tmp/check_replication_heartbeat_replica.err
        set_critical
        HEARTBEAT_COUNT="0"
    }

    if [ "$HEARTBEAT_COUNT" = "1" ]; then
        echo "OK: Heartbeat row replicated to db-replica."
    else
        echo "CRITICAL: Heartbeat row did not appear on db-replica."
        set_critical
    fi
else
    echo "CRITICAL: No heartbeat_id was returned from db-primary."
    set_critical
fi

echo ""
echo "6. Checking replay delay..."

REPLAY_DELAY_SECONDS="$(run_psql "$DB_REPLICA_HOST" "SELECT COALESCE(EXTRACT(EPOCH FROM (now() - pg_last_xact_replay_timestamp()))::integer, -1);" 2>/tmp/check_replication_replay_delay.err)" || {
    echo "WARNING: Could not calculate replay delay."
    cat /tmp/check_replication_replay_delay.err
    set_warning
    REPLAY_DELAY_SECONDS="-1"
}

if [ "$REPLAY_DELAY_SECONDS" = "-1" ]; then
    echo "WARNING: Replay delay is unknown."
    set_warning
elif [ "$REPLAY_DELAY_SECONDS" -le 300 ]; then
    echo "OK: Replay delay is ${REPLAY_DELAY_SECONDS} seconds."
else
    echo "WARNING: Replay delay is ${REPLAY_DELAY_SECONDS} seconds."
    set_warning
fi

echo ""
echo "Overall status: ${OVERALL_STATUS}"

if [ "$OVERALL_STATUS" = "OK" ]; then
    exit 0
elif [ "$OVERALL_STATUS" = "WARNING" ]; then
    exit 1
else
    exit 2
fi