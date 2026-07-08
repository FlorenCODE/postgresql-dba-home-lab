# PostgreSQL DBA Home Lab

This repository documents a hands-on PostgreSQL database administration lab designed to build practical DBA, systems administration, monitoring, automation, backup, replication, and troubleshooting skills.

The lab is intentionally built as a realistic multi-system environment rather than a single local database. It separates database servers, an operations server, an AI-assisted workstation, monitoring tools, documentation, and automation scripts.

## Purpose

The purpose of this lab is to practice the core responsibilities of a database administrator, including:

- PostgreSQL installation and administration
- Database connectivity testing
- Streaming replication configuration and validation
- Backup and restore planning
- Health-check automation
- Linux server administration
- Bash scripting
- SQL diagnostics
- Monitoring with Prometheus and Grafana
- GitHub-based documentation and portfolio development
- AI-assisted DBA operations using a local AI workstation

This lab is also intended to support career development toward database administration, systems administration, cloud monitoring, and data infrastructure roles.

## Current Lab Topology

| System | Role | Current Purpose |
|---|---|---|
| HP Envy | Hyper-V host | Main lab host running Ubuntu Server VMs |
| `db-primary` | PostgreSQL primary server | Main writable PostgreSQL database server |
| `db-replica` | PostgreSQL replica server | Streaming replica / read-only validation server |
| `db-ops` | Operations server | Automation, monitoring, health checks, reports, Prometheus, Grafana |
| Acer Nitro V 15 | AI operations workstation | Odysseus, Ollama, Docker, VS Code, GitHub documentation, script review, AI-assisted troubleshooting |
| GitHub | Source control | Stores documentation, scripts, lab evidence, and portfolio material |

## Current Network Inventory

| Host | IP Address | Purpose |
|---|---|---|
| `db-primary` | `10.0.0.129` | PostgreSQL primary |
| `db-ops` | `10.0.0.128` | Automation and monitoring server |
| `db-replica` | `10.0.0.153` | PostgreSQL streaming replica |

## Current PostgreSQL Environment

| Item | Current Value |
|---|---|
| PostgreSQL version | PostgreSQL 18.x |
| Main database | `dba_lab` |
| DBA lab user | `dbadmin` |
| Primary server | `db-primary` |
| Replica server | `db-replica` |
| Operations server | `db-ops` |

## Repository Structure

```text
postgresql-dba-home-lab/
  README.md
  PUBLICATION_CHECKLIST.md

  docs/
    ai-operations-workstation.md
    automation-plan.md
    replication-troubleshooting.md

  scripts/
    health/
      check_host_reachability.sh
      check_db_connectivity.sh
      check_replication.sh

    reports/

  sql/

  screenshots/
```

## Current Documentation

| File | Purpose |
|---|---|
| `docs/ai-operations-workstation.md` | Documents the Acer Nitro V role as the AI operations workstation |
| `docs/automation-plan.md` | Defines the DBA lab automation and health-reporting plan |
| `docs/replication-troubleshooting.md` | Documents a real replication issue, root cause, fix, and validation |
| `PUBLICATION_CHECKLIST.md` | Tracks portfolio/publication readiness |
| `linkedin-project-description.md` | Draft LinkedIn project description |
| `linkedin-progress-post.md` | Draft LinkedIn progress update |

## AI Operations Workstation

The Acer Nitro V 15 is used as the AI operations workstation for this lab.

Current Acer software stack:

| Tool | Purpose |
|---|---|
| Odysseus | AI-assisted coding and operations workspace |
| Ollama | Local AI model server |
| Docker Desktop | Runs local AI tooling and containers |
| VS Code | Documentation and script editing |
| Git | Source control |
| GitHub | Remote repository and portfolio record |
| PowerShell | Windows command-line work |
| OpenSSH | Remote access to Linux lab servers |

Current local AI models:

| Model | Purpose |
|---|---|
| `qwen2.5-coder:14b` | Main local model for DBA lab reasoning, script review, and documentation |
| `qwen2.5-coder:7b` | Fast fallback model |

The Acer is not currently used as the PostgreSQL server, replica server, or operations server. Its role is to act as an AI-assisted control center for documentation, review, troubleshooting, and planning.

## Automation Architecture

The automation design separates the AI workstation from the scheduled operations server.

```text
Acer Nitro V
  ├── Odysseus
  ├── Ollama
  ├── Docker
  ├── VS Code
  ├── GitHub repository clone
  └── AI-assisted documentation, review, and troubleshooting

db-ops
  ├── cron jobs
  ├── health-check scripts
  ├── backup validation scripts
  ├── replication validation scripts
  ├── Prometheus
  ├── Grafana
  ├── report generation scripts
  └── automated health report delivery

db-primary
  ├── PostgreSQL primary database
  ├── primary write workload
  └── replication source

db-replica
  ├── PostgreSQL replica database
  ├── recovery mode validation
  └── replication receiver
```

## Completed Automation Scripts

The lab currently has three working health-check scripts.

### Host Reachability Check

Script:

```text
scripts/health/check_host_reachability.sh
```

Purpose:

- Checks whether the core lab hosts are reachable over the network
- Verifies basic network availability before deeper database checks

Checks:

- `db-primary`
- `db-ops`
- `db-replica`

Current result:

```text
Overall status: OK
```

### PostgreSQL Connectivity Check

Script:

```text
scripts/health/check_db_connectivity.sh
```

Purpose:

- Checks whether PostgreSQL is accepting connections on the primary and replica
- Uses `pg_isready` to confirm PostgreSQL is listening on port `5432`

Checks:

- `db-primary:5432`
- `db-replica:5432`

Current result:

```text
Overall status: OK
```

### Replication Health Check

Script:

```text
scripts/health/check_replication.sh
```

Purpose:

- Validates PostgreSQL streaming replication health
- Confirms the primary and replica roles
- Confirms active streaming
- Performs a live heartbeat insert on `db-primary`
- Confirms the heartbeat row appears on `db-replica`
- Checks replay delay

Checks:

- `db-primary` is not in recovery mode
- `db-replica` is in recovery mode
- `db-primary` sees at least one streaming replica connection
- `db-replica` WAL receiver is streaming
- heartbeat row replicates from primary to replica
- replay delay is acceptable

Current result:

```text
Overall status: OK
```

## Clean Health Logs

Clean logs have been saved on `db-ops` under:

```text
logs/health/
```

Current saved logs:

```text
check_host_reachability_2026-07-08.log
check_db_connectivity_2026-07-08.log
check_replication_2026-07-08.log
```

These logs are currently generated on `db-ops`. Routine logs are not necessarily committed to GitHub because operational logs can grow over time and may include environment-specific details.

## Replication Troubleshooting Incident

During automation testing, the first two checks passed:

```text
Host reachability: OK
PostgreSQL connectivity: OK
```

However, deeper replication checks showed that `db-replica` was in recovery mode but not actively streaming.

Symptoms:

- `pg_is_in_recovery()` returned `t` on `db-replica`
- `pg_stat_replication` on `db-primary` initially returned no active replica rows
- `pg_stat_wal_receiver` on `db-replica` initially returned no active stream
- replay delay showed the replica was stale

Root cause:

```text
db-replica had an outdated /etc/hosts entry:
10.0.0.119 db-primary
```

Correct mapping:

```text
10.0.0.129 db-primary
```

Fix:

- Edited `/etc/hosts` on `db-replica`
- Corrected `db-primary` to resolve to `10.0.0.129`
- Restarted PostgreSQL on `db-replica`
- Confirmed WAL receiver resumed streaming
- Confirmed `db-primary` saw `db-replica` as streaming
- Inserted a heartbeat row on `db-primary`
- Confirmed the row appeared on `db-replica`

This incident is documented in:

```text
docs/replication-troubleshooting.md
```

## Key DBA Concepts Practiced

This lab currently demonstrates:

- PostgreSQL service validation
- PostgreSQL client connectivity testing
- Primary/replica architecture
- Streaming replication validation
- WAL receiver troubleshooting
- Replay delay analysis
- Live replication heartbeat testing
- Linux hostname resolution troubleshooting
- `/etc/hosts` management
- PostgreSQL log review
- Bash health-check scripting
- Git and GitHub workflow
- AI-assisted documentation and script review

## Common Commands

### SSH into `db-ops`

```powershell
ssh floren@10.0.0.128
```

### SSH into `db-replica`

```powershell
ssh floren@10.0.0.153
```

### Move into the repository on `db-ops`

```bash
cd ~/postgresql-dba-home-lab
```

### Pull latest repository changes on `db-ops`

```bash
git pull
```

### Run host reachability check

```bash
./scripts/health/check_host_reachability.sh
```

### Run PostgreSQL connectivity check

```bash
./scripts/health/check_db_connectivity.sh
```

### Run replication health check

```bash
./scripts/health/check_replication.sh
```

### Save a health-check log

```bash
./scripts/health/check_replication.sh | tee logs/health/check_replication_$(date +%F).log
```

## Git Workflow

Current workflow:

```text
Acer Nitro V = edit, commit, and push
db-ops       = pull and run scripts
```

This keeps `db-ops` simple and avoids needing GitHub write credentials on the operations server.

### Commit and push from the Acer

Run from:

```text
C:\DBA-Lab\postgresql-dba-home-lab
```

Commands:

```powershell
git status
git add README.md
git commit -m "Update README with current DBA lab status"
git push
```

### Pull updates on `db-ops`

Run from:

```text
~/postgresql-dba-home-lab
```

Commands:

```bash
git pull
```

## Planned Next Steps

Next planned automation work:

1. Create `scripts/health/check_system_resources.sh`
2. Check disk space on `db-ops`
3. Check memory usage on `db-ops`
4. Check CPU load and uptime
5. Save system health logs
6. Add backup validation script
7. Add Prometheus health check
8. Add Grafana health check
9. Build a daily health report generator
10. Configure email delivery for automated health reports
11. Schedule the final report with `cron`

## Planned Health Report Scope

The final daily DBA lab health report should include:

- `db-primary` reachable
- `db-replica` reachable
- `db-ops` reachable
- PostgreSQL service running
- PostgreSQL accepting connections
- replica is in recovery mode
- primary sees streaming replica
- replica WAL receiver is streaming
- heartbeat row replication test
- replication replay delay
- latest backup exists
- backup file size looks valid
- row count validation
- Prometheus targets are up
- Grafana service is running
- Grafana is reachable
- disk space
- RAM usage
- CPU/load snapshot
- GitHub repository status

## Learning Method

This lab prioritizes learning over shortcuts.

For each script, the learning process should include:

1. Define the purpose of the check.
2. Run the underlying command manually.
3. Understand the expected output.
4. Understand failure modes.
5. Turn the command into a script.
6. Add clear `OK`, `WARNING`, and `CRITICAL` statuses.
7. Test the script manually.
8. Save a log.
9. Document the result.
10. Commit the script and documentation to GitHub.

## Portfolio Summary

This PostgreSQL DBA home lab demonstrates a multi-server database administration environment with a primary PostgreSQL server, streaming replica, operations server, AI-assisted workstation, GitHub documentation, and working health-check automation.

The lab includes real troubleshooting evidence, including detection and repair of a stale streaming replica caused by an outdated hostname-to-IP mapping. The issue was diagnosed through PostgreSQL system views, replay delay checks, WAL receiver status, service logs, and a live heartbeat replication test.

The project is being developed as a practical DBA learning environment and portfolio project.