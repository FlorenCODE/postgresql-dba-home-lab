# PostgreSQL Streaming Replication Checkpoint

## Purpose

This checkpoint documents the PostgreSQL streaming replication setup between the primary database server and the replica database server in the DBA home lab.

The goal of this milestone is to demonstrate that the lab can support a primary/replica PostgreSQL architecture similar to what is used in real database administration environments.

## Lab Architecture

| Component | Role | Platform |
|---|---|---|
| `db-primary` | PostgreSQL primary / writable server | Ubuntu Server VM on Hyper-V |
| `db-replica` | PostgreSQL standby / read-only replica | Bare-metal Ubuntu Server desktop |

## Database

| Item | Value |
|---|---|
| Database name | dba_lab |
| PostgreSQL version | PostgreSQL 18.4 |
| Primary role | Writable source database |
| Replica role | Read-only standby database |

## Primary/Replica Validation

The following query was used to confirm whether each server was acting as the primary or the replica:

```sql
SELECT pg_is_in_recovery();


## Replication Evidence Checkpoint - 2026-06-29

### Server Roles

| Server | Role | Validation Result |
|---|---|---|
| `db-primary` | Writable PostgreSQL primary | `pg_is_in_recovery() = false` |
| `db-replica` | Read-only PostgreSQL standby replica | `pg_is_in_recovery() = true` |

### Streaming Replication Status

The following query was executed on `db-primary`:

```sql
SELECT
    client_addr,
    usename,
    application_name,
    state,
    sync_state,
    sent_lsn,
    write_lsn,
    flush_lsn,
    replay_lsn,
    write_lag,
    flush_lag,
    replay_lag
FROM pg_stat_replication;