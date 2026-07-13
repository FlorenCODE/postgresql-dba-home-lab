#!/usr/bin/env bash

# check_system_resources.sh
# Purpose:
#   Check disk usage, memory usage, CPU load, and uptime on db-ops.
#
# Intended run location:
#   db-ops

set -euo pipefail

DISK_WARNING=80
DISK_CRITICAL=90
MEMORY_WARNING=80
MEMORY_CRITICAL=90
LOAD_WARNING=100
LOAD_CRITICAL=200

OVERALL_STATUS="OK"

raise_status() {
    local new_status="$1"

    if [ "$new_status" = "CRITICAL" ]; then
        OVERALL_STATUS="CRITICAL"
    elif [ "$new_status" = "WARNING" ] && [ "$OVERALL_STATUS" = "OK" ]; then
        OVERALL_STATUS="WARNING"
    fi
}

check_disk() {
    local used_percent

    used_percent=$(df -P / | awk 'NR == 2 {gsub("%", "", $5); print $5}')

    echo "Root filesystem usage: ${used_percent}%"

    if [ "$used_percent" -ge "$DISK_CRITICAL" ]; then
        echo "CRITICAL: Root filesystem usage is at or above ${DISK_CRITICAL}%."
        raise_status "CRITICAL"
    elif [ "$used_percent" -ge "$DISK_WARNING" ]; then
        echo "WARNING: Root filesystem usage is at or above ${DISK_WARNING}%."
        raise_status "WARNING"
    else
        echo "OK: Root filesystem usage is below ${DISK_WARNING}%."
    fi

    echo ""
}

check_memory() {
    local total_kb
    local available_kb
    local used_percent

    total_kb=$(awk '/MemTotal:/ {print $2}' /proc/meminfo)
    available_kb=$(awk '/MemAvailable:/ {print $2}' /proc/meminfo)
    used_percent=$(( (total_kb - available_kb) * 100 / total_kb ))

    echo "Memory usage: ${used_percent}%"

    if [ "$used_percent" -ge "$MEMORY_CRITICAL" ]; then
        echo "CRITICAL: Memory usage is at or above ${MEMORY_CRITICAL}%."
        raise_status "CRITICAL"
    elif [ "$used_percent" -ge "$MEMORY_WARNING" ]; then
        echo "WARNING: Memory usage is at or above ${MEMORY_WARNING}%."
        raise_status "WARNING"
    else
        echo "OK: Memory usage is below ${MEMORY_WARNING}%."
    fi

    free -h
    echo ""
}

check_load() {
    local cpu_count
    local load_1m
    local load_percent

    cpu_count=$(nproc)
    load_1m=$(awk '{print $1}' /proc/loadavg)
    load_percent=$(awk -v current_load="$load_1m" -v cpus="$cpu_count" 'BEGIN {printf "%.0f", (current_load / cpus) * 100}')

    echo "Logical CPU count: ${cpu_count}"
    echo "1-minute load average: ${load_1m}"
    echo "Load relative to CPU count: ${load_percent}%"

    if [ "$load_percent" -ge "$LOAD_CRITICAL" ]; then
        echo "CRITICAL: CPU load is at or above ${LOAD_CRITICAL}% of logical CPU capacity."
        raise_status "CRITICAL"
    elif [ "$load_percent" -ge "$LOAD_WARNING" ]; then
        echo "WARNING: CPU load is at or above ${LOAD_WARNING}% of logical CPU capacity."
        raise_status "WARNING"
    else
        echo "OK: CPU load is below ${LOAD_WARNING}% of logical CPU capacity."
    fi

    echo ""
}

echo "DBA Lab System Resource Check"
echo "Host: $(hostname)"
echo "Generated at: $(date --iso-8601=seconds)"
echo "Uptime: $(uptime -p)"
echo ""

check_disk
check_memory
check_load

echo "Overall status: ${OVERALL_STATUS}"

case "$OVERALL_STATUS" in
    OK)
        exit 0
        ;;
    WARNING)
        exit 1
        ;;
    CRITICAL)
        exit 2
        ;;
esac