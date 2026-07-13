# Automation Status

## Purpose

This document summarizes the current automation state of the PostgreSQL DBA home lab. It focuses on the completed health-check scripts, their role in the lab, and the operating model used on db-ops.

## Current architecture

The automation workflow is split across the lab systems:

- Acer Nitro V: review, planning, documentation, and GitHub workflow support
- db-ops: execution of validated health checks and future scheduling work
- db-primary: PostgreSQL primary server
- db-replica: PostgreSQL replica server

## Current execution model

The completed health checks are designed to be run manually from db-ops and later wrapped by cron or other scheduling tools. The scripts are intentionally straightforward so they can be understood, tested, and documented.

## Completed scripts

| Script | Status | What it validates | Run location |
|---|---|---|---|
| scripts/health/check_host_reachability.sh | Completed | Basic reachability of the core lab hosts | db-ops |
| scripts/health/check_db_connectivity.sh | Completed | PostgreSQL readiness on the primary and replica | db-ops |
| scripts/health/check_replication.sh | Completed | Replication role, WAL receiver activity, heartbeat propagation, and replay delay | db-ops |
| scripts/health/check_system_resources.sh | Completed and validated | Disk usage, memory usage, CPU-normalized load, and uptime | db-ops |

## Current verification status

The system resource script was validated directly on db-ops. The validation confirmed:

- Bash syntax check passed with exit code 0
- The script reported the correct host
- Disk, memory, CPU load, and uptime checks worked
- The overall status was OK
- The script exited with code 0

## Exit-code conventions

The scripts use exit codes to communicate their final status:

- `0` means OK
- `1` means WARNING, when the script implements a warning state
- `2` means CRITICAL

The host reachability and database connectivity checks currently return either OK or CRITICAL. The replication and system resource checks also support a WARNING state.

Future wrappers or cron jobs must deliberately capture these exit codes instead of treating every nonzero result identically.

## Logging approach

Operational runs can be logged to files on db-ops. The repository keeps the scripts and documentation version-controlled while leaving operational logs outside the main source tree when appropriate.

## Replication troubleshooting milestone

The repository also documents a real replication troubleshooting milestone in the [replication troubleshooting documentation](replication-troubleshooting.md). That work included identifying a stale hostname mapping, restoring replication, and validating streaming behavior with a live heartbeat row.

## System resource validation

The system resource check confirmed the following observed values during validation:

- Root filesystem usage around 53 percent
- Memory usage around 22 percent
- Four logical CPUs
- One-minute load average around 0.09
- CPU-normalized load around 2 percent

## In-progress items

- Backup validation workflow
- Report generation and scheduling workflow
- Monitoring integration planning for Prometheus and Grafana

## Planned automation stages

### Stage 1

- Keep the four health checks as manually runnable, documented scripts

### Stage 2

- Add scheduling and log rotation on db-ops

### Stage 3

- Add report generation and delivery concepts for operational summaries

### Stage 4

- Add monitoring and visualization components where they are justified by the lab scope
