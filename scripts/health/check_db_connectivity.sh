#!/usr/bin/env bash

# check_db_connectivity.sh
# Purpose:
#   Check whether PostgreSQL is accepting connections on the DBA lab database servers.
#
# Intended run location:
#   db-ops
#
# Hosts checked:
#   db-primary  = 10.0.0.129
#   db-replica  = 10.0.0.153
#
# This script uses pg_isready. It checks whether PostgreSQL is listening
# and accepting connections, but it does not authenticate into the database.

set -u

DB_PRIMARY_IP="10.0.0.129"
DB_REPLICA_IP="10.0.0.153"
POSTGRES_PORT="5432"

OVERALL_STATUS="OK"

check_postgres_ready() {
    local host_name="$1"
    local host_ip="$2"

    echo "Checking PostgreSQL connectivity for ${host_name} at ${host_ip}:${POSTGRES_PORT}..."

    if pg_isready -h "$host_ip" -p "$POSTGRES_PORT" > /dev/null 2>&1; then
        echo "OK: PostgreSQL on ${host_name} is accepting connections."
    else
        echo "CRITICAL: PostgreSQL on ${host_name} is not accepting connections."
        OVERALL_STATUS="CRITICAL"
    fi

    echo ""
}

echo "PostgreSQL DBA Lab Database Connectivity Check"
echo "Generated at: $(date)"
echo ""

check_postgres_ready "db-primary" "$DB_PRIMARY_IP"
check_postgres_ready "db-replica" "$DB_REPLICA_IP"

echo "Overall status: ${OVERALL_STATUS}"

if [ "$OVERALL_STATUS" = "OK" ]; then
    exit 0
else
    exit 2
fi