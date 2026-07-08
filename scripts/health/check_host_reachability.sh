#!/usr/bin/env bash

# check_host_reachability.sh
# Purpose:
#   Check whether the core DBA lab hosts are reachable from the operations server.
#
# Intended run location:
#   db-ops
#
# Hosts checked:
#   db-primary  = 10.0.0.129
#   db-ops      = 10.0.0.128
#   db-replica  = 10.0.0.153

set -u

DB_PRIMARY_IP="10.0.0.129"
DB_OPS_IP="10.0.0.128"
DB_REPLICA_IP="10.0.0.153"

OVERALL_STATUS="OK"

check_host() {
    local host_name="$1"
    local host_ip="$2"

    echo "Checking ${host_name} at ${host_ip}..."

    if ping -c 3 -W 2 "$host_ip" > /dev/null 2>&1; then
        echo "OK: ${host_name} is reachable."
    else
        echo "CRITICAL: ${host_name} is not reachable."
        OVERALL_STATUS="CRITICAL"
    fi

    echo ""
}

echo "PostgreSQL DBA Lab Host Reachability Check"
echo "Generated at: $(date)"
echo ""

check_host "db-primary" "$DB_PRIMARY_IP"
check_host "db-ops" "$DB_OPS_IP"
check_host "db-replica" "$DB_REPLICA_IP"

echo "Overall status: ${OVERALL_STATUS}"

if [ "$OVERALL_STATUS" = "OK" ]; then
    exit 0
else
    exit 2
fi