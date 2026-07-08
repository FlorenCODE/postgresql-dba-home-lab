# Replication Troubleshooting: Stale Replica After Primary IP Change

This document records a PostgreSQL streaming replication issue found during DBA lab automation testing.

## Summary

During automation testing, the lab health checks showed that the core systems were reachable and PostgreSQL was accepting connections, but replication was not fully healthy.

The replica server was still in recovery mode, but it was not actively streaming from the primary server.

The root cause was an outdated hostname mapping on `db-replica`. The hostname `db-primary` still resolved to the old primary IP address, `10.0.0.119`, instead of the current primary IP address, `10.0.0.129`.

After correcting the hostname mapping, restarting PostgreSQL on `db-replica`, and validating with PostgreSQL replication views and a live heartbeat insert, streaming replication was confirmed working again.

## Systems Involved

| System | Role | IP Address |
|---|---|---|
| `db-primary` | PostgreSQL primary server | `10.0.0.129` |
| `db-replica` | PostgreSQL streaming replica | `10.0.0.153` |
| `db-ops` | Operations and automation server | `10.0.0.128` |
| Acer Nitro V | AI operations workstation | Local workstation |

## Initial Health Check Results

The first two automation scripts passed successfully.

### Host Reachability

Script:

```text
scripts/health/check_host_reachability.sh
```

Result:

```text
db-primary reachable: OK
db-ops reachable: OK
db-replica reachable: OK
Overall status: OK
```

This confirmed that the core lab systems were reachable over the network.

### PostgreSQL Connectivity

Script:

```text
scripts/health/check_db_connectivity.sh
```

Result:

```text
db-primary PostgreSQL accepting connections: OK
db-replica PostgreSQL accepting connections: OK
Overall status: OK
```

This confirmed that PostgreSQL was listening and accepting connections on port `5432` for both the primary and replica servers.

However, these checks did not prove that streaming replication was healthy.

## Problem Detected

Manual replication checks showed that `db-replica` was still in recovery mode:

```sql
SELECT pg_is_in_recovery();
```

Result on `db-replica`:

```text
t
```

This confirmed that `db-replica` was still acting as a standby server.

However, the primary did not show an active streaming replica connection:

```sql
SELECT client_addr, state, sync_state, write_lag, flush_lag, replay_lag
FROM pg_stat_replication;
```

Initial result on `db-primary`:

```text
(0 rows)
```

The replica-side WAL receiver also showed no active stream:

```sql
SELECT status, sender_host, sender_port, latest_end_lsn, latest_end_time
FROM pg_stat_wal_receiver;
```

Initial result on `db-replica`:

```text
(0 rows)
```

This meant that the replica was configured as a standby, but it was not actively streaming WAL records from the primary.

## Diagnostic Findings

The replica was stale.

A replay-status query showed that the replica had not replayed recent WAL activity:

```sql
SELECT
    now() AS checked_at,
    pg_is_in_recovery() AS replica_in_recovery,
    pg_last_wal_receive_lsn() AS last_receive_lsn,
    pg_last_wal_replay_lsn() AS last_replay_lsn,
    pg_last_xact_replay_timestamp() AS last_replay_time,
    now() - pg_last_xact_replay_timestamp() AS replay_delay;
```

The result showed:

```text
replica_in_recovery: t
last_replay_time: 2026-07-01
replay_delay: approximately 6 days 20 hours
```

This was a critical finding. It showed that the replica was in standby mode but had not replayed new transactions for several days.

## PostgreSQL Log Evidence

The PostgreSQL log on `db-replica` showed repeated streaming receiver connection failures:

```text
streaming replication receiver could not connect to the primary server:
connection to server at "db-primary" (10.0.0.119), port 5432 failed:
No route to host
```

This showed that `db-replica` was trying to connect to the old primary IP address:

```text
10.0.0.119
```

The correct current IP address for `db-primary` is:

```text
10.0.0.129
```

## Root Cause

The root cause was an outdated `/etc/hosts` entry on `db-replica`.

Old incorrect mapping:

```text
10.0.0.119 db-primary
```

Correct mapping:

```text
10.0.0.129 db-primary
```

PostgreSQL replication was configured to connect to:

```text
host='db-primary'
```

Because `db-primary` resolved to the old IP address, the replica tried to stream from the wrong host. That caused the WAL receiver to fail repeatedly with `No route to host`.

## Fix Applied

On `db-replica`, the `/etc/hosts` file was edited.

The old mapping was replaced with:

```text
10.0.0.129 db-primary
```

After saving the file, hostname resolution was confirmed:

```bash
getent hosts db-primary
```

Expected result:

```text
10.0.0.129 db-primary
```

PostgreSQL reachability through the hostname was then confirmed:

```bash
pg_isready -h db-primary -p 5432
```

Result:

```text
db-primary:5432 - accepting connections
```

The PostgreSQL replica cluster was restarted:

```bash
sudo systemctl restart postgresql@18-main
```

## Validation After the Fix

After the fix, the replica-side WAL receiver showed active streaming:

```sql
SELECT status, sender_host, sender_port, latest_end_lsn, latest_end_time
FROM pg_stat_wal_receiver;
```

Result:

```text
status    | sender_host | sender_port | latest_end_lsn | latest_end_time
----------+-------------+-------------+----------------+------------------------------
streaming | db-primary  | 5432        | 0/35F7CB8      | 2026-07-08 06:30:16.52649+00
```

The primary-side replication view showed the replica connected:

```sql
SELECT client_addr, state, sync_state, write_lag, flush_lag, replay_lag
FROM pg_stat_replication;
```

Result:

```text
client_addr | state     | sync_state
------------+-----------+------------
10.0.0.153  | streaming | async
```

## Live Heartbeat Validation

A live heartbeat row was inserted on `db-primary`:

```sql
INSERT INTO lab_admin.replication_heartbeat (source_server, note)
VALUES ('db-primary', 'replication test after db-primary IP mapping fix')
RETURNING heartbeat_id, source_server, note, created_at;
```

Result:

```text
heartbeat_id | source_server | note                                             | created_at
-------------+---------------+--------------------------------------------------+-------------------------------
5            | db-primary    | replication test after db-primary IP mapping fix | 2026-07-08 06:44:39.469776+00
```

The row appeared on `db-replica`:

```sql
SELECT heartbeat_id, source_server, note, created_at
FROM lab_admin.replication_heartbeat
ORDER BY heartbeat_id DESC
LIMIT 5;
```

Result:

```text
heartbeat_id | source_server | note                                             | created_at
-------------+---------------+--------------------------------------------------+-------------------------------
5            | db-primary    | replication test after db-primary IP mapping fix | 2026-07-08 06:44:39.469776+00
```

This confirmed that live data changes were replicating from `db-primary` to `db-replica`.

## Replay Status After Fix

Replay status was checked again:

```sql
SELECT
    now() AS checked_at,
    pg_is_in_recovery() AS replica_in_recovery,
    pg_last_wal_receive_lsn() AS last_receive_lsn,
    pg_last_wal_replay_lsn() AS last_replay_lsn,
    pg_last_xact_replay_timestamp() AS last_replay_time,
    now() - pg_last_xact_replay_timestamp() AS replay_delay;
```

Result:

```text
replica_in_recovery | last_receive_lsn | last_replay_lsn | last_replay_time              | replay_delay
--------------------+------------------+-----------------+-------------------------------+-----------------
t                   | 0/35F9B90        | 0/35F9B90       | 2026-07-08 06:44:39.472441+00 | 00:01:18.579777
```

This showed that the receive and replay LSN values matched and that the replica was current.

## Automation Validation

The replication health-check script was then created and corrected:

```text
scripts/health/check_replication.sh
```

The corrected script validates:

- `db-primary` is not in recovery mode
- `db-replica` is in recovery mode
- `db-primary` sees at least one streaming replica connection
- `db-replica` WAL receiver is streaming
- a heartbeat row inserted on `db-primary` appears on `db-replica`
- replay delay is acceptable

Final clean result:

```text
PostgreSQL DBA Lab Replication Health Check
Generated at: Wed Jul  8 07:00:44 AM UTC 2026

1. Checking primary recovery status...
OK: db-primary is not in recovery mode.

2. Checking replica recovery status...
OK: db-replica is in recovery mode.

3. Checking primary-side replication status...
OK: db-primary sees 1 streaming replica connection(s).
Primary-side replication details:
10.0.0.153|streaming|async|||

4. Checking replica-side WAL receiver status...
OK: db-replica WAL receiver is streaming.
Replica-side WAL receiver details:
streaming|db-primary|5432|0/35FA670|2026-07-08 06:59:46.850753+00

5. Performing active heartbeat replication test...
Inserted heartbeat_id 8 on db-primary.
OK: Heartbeat row replicated to db-replica.

6. Checking replay delay...
OK: Replay delay is 3 seconds.

Overall status: OK
```

A clean log was saved on `db-ops`:

```text
logs/health/check_replication_2026-07-08.log
```

## Current Working Health Scripts

The lab currently has three working health-check scripts:

```text
scripts/health/check_host_reachability.sh
scripts/health/check_db_connectivity.sh
scripts/health/check_replication.sh
```

Clean logs saved on `db-ops`:

```text
logs/health/check_host_reachability_2026-07-08.log
logs/health/check_db_connectivity_2026-07-08.log
logs/health/check_replication_2026-07-08.log
```

## DBA Lessons Learned

This incident demonstrates several important DBA skills:

- Basic host reachability checks are not enough to prove replication health.
- PostgreSQL can be accepting connections while replication is stale or disconnected.
- `pg_is_in_recovery()` confirms standby mode, but it does not prove active streaming.
- `pg_stat_replication` should be checked on the primary.
- `pg_stat_wal_receiver` should be checked on the replica.
- Replay delay should be checked to detect stale replicas.
- PostgreSQL logs are essential for identifying the root cause of replication failures.
- Hostname resolution can break replication after an IP address change.
- `/etc/hosts` mappings should be updated when lab IP addresses change.
- A live heartbeat insert is a strong validation method because it proves actual data changes replicate.
- Automation scripts should be tested manually before being scheduled with `cron`.

## Commands Used During Troubleshooting

Check whether the replica is in recovery mode:

```sql
SELECT pg_is_in_recovery();
```

Check primary-side replication status:

```sql
SELECT client_addr, state, sync_state, write_lag, flush_lag, replay_lag
FROM pg_stat_replication;
```

Check replica-side WAL receiver status:

```sql
SELECT status, sender_host, sender_port, latest_end_lsn, latest_end_time
FROM pg_stat_wal_receiver;
```

Check replay status:

```sql
SELECT
    now() AS checked_at,
    pg_is_in_recovery() AS replica_in_recovery,
    pg_last_wal_receive_lsn() AS last_receive_lsn,
    pg_last_wal_replay_lsn() AS last_replay_lsn,
    pg_last_xact_replay_timestamp() AS last_replay_time,
    now() - pg_last_xact_replay_timestamp() AS replay_delay;
```

Check hostname resolution:

```bash
getent hosts db-primary
```

Check PostgreSQL readiness through the hostname:

```bash
pg_isready -h db-primary -p 5432
```

Restart the PostgreSQL replica cluster:

```bash
sudo systemctl restart postgresql@18-main
```

Check PostgreSQL logs:

```bash
sudo tail -n 120 /var/log/postgresql/postgresql-18-main.log
```

## Portfolio Summary

During DBA lab automation testing, a stale PostgreSQL streaming replica was detected. Initial network and database connectivity checks passed, but deeper replication checks showed that the standby was not actively streaming. PostgreSQL logs revealed that `db-replica` was resolving `db-primary` to an outdated IP address. The `/etc/hosts` mapping was corrected, PostgreSQL was restarted on the replica, and replication was validated using `pg_stat_replication`, `pg_stat_wal_receiver`, replay delay checks, and a live heartbeat insert from primary to replica.

This incident demonstrates practical DBA troubleshooting, replication validation, Linux system administration, log analysis, SQL diagnostics, and automation script development.