# DBA Lab Automation Plan

This document defines the automation plan for the PostgreSQL DBA home lab.

The goal is to build a realistic database administration automation workflow that checks database availability, PostgreSQL service health, replication status, backup readiness, monitoring tools, system resources, and GitHub documentation status.

This plan is also a learning roadmap. Each automation component should help build practical DBA, systems administration, Linux, scripting, monitoring, and documentation skills.

## Purpose

The purpose of the DBA lab automation system is to:

- Monitor whether the lab systems are reachable
- Confirm PostgreSQL is running where expected
- Validate that replication is working
- Check whether backups exist and appear valid
- Confirm Prometheus is collecting metrics
- Confirm Grafana is available for dashboards
- Report disk, RAM, and CPU status
- Track whether the GitHub repository has uncommitted changes
- Send automated health reports
- Build real-world DBA automation skills

The automation system should not hide what is happening. It should be designed so each check can be understood, run manually, documented, and later scheduled.

## Current Lab Topology

The current PostgreSQL DBA lab uses the following systems:

| System | Role | Current Purpose |
|---|---|---|
| HP Envy | Hyper-V host | Main lab host running virtual machines |
| `db-primary` | PostgreSQL primary server | Main writable PostgreSQL database server |
| `db-replica` | PostgreSQL replica server | Streaming replica / read-only validation server |
| `db-ops` | Operations server | Automation, monitoring, health checks, reports, Prometheus, Grafana |
| Acer Nitro V 15 | AI operations workstation | Odysseus, Ollama, Docker, GitHub documentation, script review, AI-assisted troubleshooting |
| GitHub | Source control | Stores documentation, scripts, lab evidence, and portfolio material |

Known lab IP addresses:

| Host | IP Address |
|---|---|
| `db-primary` | `10.0.0.129` |
| `db-ops` | `10.0.0.128` |
| `db-replica` | `10.0.0.153` |

## Automation Architecture

The lab automation architecture separates the AI workstation from the scheduled automation server.

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

## Role of the Acer Nitro V

The Acer Nitro V is the AI operations workstation for the lab.

The Acer is used to:

- Edit the GitHub repository
- Write and improve Markdown documentation
- Use Odysseus with local Ollama models
- Review SQL, Bash, and Python scripts
- Explain automation commands before they are run
- Help troubleshoot failed checks
- Generate report templates
- Review health report output
- Draft portfolio and resume descriptions
- Document DBA learning progress

The Acer should not be the main database server or the main scheduled automation server.

The current local AI setup on the Acer is:

| Component | Current Setup |
|---|---|
| AI workspace | Odysseus |
| Local model server | Ollama |
| Main local model | `qwen2.5-coder:14b` |
| Fast fallback model | `qwen2.5-coder:7b` |
| Docker endpoint | `http://host.docker.internal:11434/v1` |

## Role of `db-ops`

The `db-ops` server is the main automation and monitoring server.

The `db-ops` server should run:

- Scheduled health checks
- PostgreSQL connection checks
- Replication checks
- Backup validation checks
- Prometheus monitoring
- Grafana dashboards
- Report generation scripts
- Email report delivery
- Log collection for automation jobs

This design reflects a realistic DBA environment because database servers, monitoring servers, automation servers, and administrator workstations are usually separated.

## Software and Methods

The lab automation workflow will use the following tools and methods.

### Acer Nitro V Software

| Tool | Purpose |
|---|---|
| Odysseus | AI-assisted DBA workspace |
| Ollama | Local model server |
| `qwen2.5-coder:14b` | Main local reasoning and coding model |
| Docker Desktop | Runs Odysseus and related local services |
| VS Code | Repository editing and documentation |
| Git | Source control from the command line |
| GitHub | Remote repository and portfolio record |
| PowerShell | Windows command-line work |
| OpenSSH | Remote access to Linux systems |

### `db-ops` Software

| Tool | Purpose |
|---|---|
| Ubuntu Server | Operations server operating system |
| Bash | Shell scripting |
| Python | Report generation and email automation |
| `psql` | PostgreSQL SQL checks |
| `pg_isready` | PostgreSQL readiness checks |
| `cron` | Scheduled automation |
| Prometheus | Metrics collection |
| Grafana | Dashboard visualization |
| Node Exporter | Linux system metrics |
| PostgreSQL Exporter | PostgreSQL metrics for Prometheus |
| `systemctl` | Linux service checks |
| `journalctl` | Service log troubleshooting |

## Operating Principle

The lab should prioritize learning over shortcuts.

Each automation script should be:

- Understandable
- Manually runnable
- Documented
- Testable
- Safe
- Logged
- Version-controlled in GitHub

The goal is not only to automate the lab. The goal is to learn how DBAs monitor, validate, troubleshoot, document, and report on database systems.

## Health Report Scope

The automated DBA lab health report should check the following areas.

### Host Reachability

| Check | Purpose |
|---|---|
| `db-primary` reachable | Confirms the primary database server is online |
| `db-replica` reachable | Confirms the replica server is online |
| `db-ops` reachable | Confirms the operations server is online |

Possible methods:

```bash
ping -c 3 10.0.0.129
ping -c 3 10.0.0.153
ping -c 3 10.0.0.128
```

### PostgreSQL Connectivity

| Check | Purpose |
|---|---|
| `db-primary` accepts PostgreSQL connections | Confirms the primary database is reachable through PostgreSQL |
| `db-replica` accepts PostgreSQL connections | Confirms the replica database is reachable through PostgreSQL |
| `dbadmin` can connect to `dba_lab` | Confirms the expected DBA lab user and database are usable |

Possible methods:

```bash
pg_isready -h 10.0.0.129 -p 5432
pg_isready -h 10.0.0.153 -p 5432
```

Possible SQL connection check:

```bash
psql -h 10.0.0.129 -U dbadmin -d dba_lab -c "SELECT current_database(), current_user, now();"
```

### PostgreSQL Service Health

| Check | Purpose |
|---|---|
| PostgreSQL service running on `db-primary` | Confirms the primary PostgreSQL service is active |
| PostgreSQL service running on `db-replica` | Confirms the replica PostgreSQL service is active |

Possible method when running locally on a server:

```bash
systemctl is-active postgresql
```

Possible method when checking remotely through SSH:

```bash
ssh floren@10.0.0.129 "systemctl is-active postgresql"
ssh floren@10.0.0.153 "systemctl is-active postgresql"
```

### Replication Health

| Check | Purpose |
|---|---|
| Replica is in recovery mode | Confirms the replica is acting as a standby |
| Primary sees replica connection | Confirms the primary knows a replica is connected |
| Replica WAL receiver is active | Confirms the replica is receiving WAL records |
| Replication lag is acceptable | Confirms the replica is not too far behind |

Replica recovery mode check:

```sql
SELECT pg_is_in_recovery();
```

Expected result on `db-replica`:

```text
t
```

Primary-side replication status check:

```sql
SELECT
    client_addr,
    state,
    sync_state,
    write_lag,
    flush_lag,
    replay_lag
FROM pg_stat_replication;
```

Replica-side WAL receiver check:

```sql
SELECT
    status,
    sender_host,
    sender_port,
    latest_end_lsn,
    latest_end_time
FROM pg_stat_wal_receiver;
```

### Backup Health

| Check | Purpose |
|---|---|
| Latest backup exists | Confirms a backup file was created |
| Backup file size looks valid | Helps detect empty or failed backups |
| Backup age is acceptable | Confirms the backup is recent |
| Restore validation status is known | Confirms whether restore testing has been completed |

Possible methods:

```bash
ls -lh /var/backups/postgresql/
find /var/backups/postgresql/ -type f -mtime -1
```

Possible backup file size check:

```bash
du -h /var/backups/postgresql/latest_backup.sql
```

### Data Validation

| Check | Purpose |
|---|---|
| Row counts can be queried | Confirms important tables are readable |
| Expected schemas exist | Confirms the database structure is still present |
| Validation queries complete successfully | Confirms basic database integrity checks can run |

Possible schema check:

```sql
SELECT schema_name
FROM information_schema.schemata
WHERE schema_name IN ('app', 'audit', 'security', 'reporting')
ORDER BY schema_name;
```

Possible table count check:

```sql
SELECT table_schema, COUNT(*) AS table_count
FROM information_schema.tables
WHERE table_schema IN ('app', 'audit', 'security', 'reporting')
GROUP BY table_schema
ORDER BY table_schema;
```

### Prometheus Health

| Check | Purpose |
|---|---|
| Prometheus service running | Confirms monitoring service is active |
| Prometheus web UI reachable | Confirms the monitoring interface is reachable |
| Prometheus targets are up | Confirms configured exporters are being scraped |

Possible service check:

```bash
systemctl is-active prometheus
```

Possible web check:

```bash
curl -s http://localhost:9090/-/ready
```

Possible API target check:

```bash
curl -s http://localhost:9090/api/v1/targets
```

Expected target examples:

- Prometheus target
- Node Exporter target
- PostgreSQL Exporter target, when configured

### Grafana Health

| Check | Purpose |
|---|---|
| Grafana service running | Confirms Grafana is active |
| Grafana web UI reachable | Confirms the dashboard interface is accessible |
| Grafana dashboard exists or loads | Confirms visual monitoring is available |

Possible service check:

```bash
systemctl is-active grafana-server
```

Possible web check:

```bash
curl -I http://localhost:3000
```

Grafana should eventually include dashboards for:

- PostgreSQL database metrics
- Linux system metrics
- CPU usage
- RAM usage
- Disk usage
- PostgreSQL connections
- Replication-related metrics, if available

### System Resource Health

| Check | Purpose |
|---|---|
| Disk space | Prevents database and backup failures |
| RAM usage | Detects resource pressure |
| CPU load | Detects system stress |
| Uptime | Confirms system stability |

Possible disk check:

```bash
df -h
```

Possible memory check:

```bash
free -h
```

Possible CPU/load check:

```bash
uptime
```

### GitHub Repository Status

| Check | Purpose |
|---|---|
| Repository exists on Acer | Confirms local documentation workspace exists |
| Repository has no unexpected uncommitted changes | Confirms documentation/scripts are committed |
| Repository can push to GitHub | Confirms portfolio record can be updated |

Possible method on the Acer:

```powershell
cd C:\DBA-Lab\postgresql-dba-home-lab
git status
```

Possible method on Linux if the repo is cloned to `db-ops`:

```bash
cd ~/postgresql-dba-home-lab
git status
```

## Planned Repository Structure

The planned repository structure for automation work is:

```text
docs/
  ai-operations-workstation.md
  automation-plan.md
  monitoring-plan.md
  backup-restore-plan.md
  replication-checks.md

scripts/
  health/
    check_host_reachability.sh
    check_db_primary.sh
    check_db_replica.sh
    check_replication.sh
    check_backups.sh
    check_prometheus.sh
    check_grafana.sh
    check_system_resources.sh
    check_row_counts.sql

  reports/
    daily_health_report.py

logs/
  health/
  reports/
```

## Script Responsibilities

### `check_host_reachability.sh`

Purpose:

- Ping the core lab systems
- Confirm basic network connectivity
- Report whether each host is reachable

Checks:

- `db-primary`
- `db-replica`
- `db-ops`

### `check_db_primary.sh`

Purpose:

- Confirm the primary PostgreSQL server is reachable
- Confirm PostgreSQL accepts connections
- Confirm the expected database and user can connect

Checks:

- `pg_isready`
- `psql` connection to `dba_lab`
- Basic SQL query

### `check_db_replica.sh`

Purpose:

- Confirm the replica PostgreSQL server is reachable
- Confirm PostgreSQL accepts connections
- Confirm the replica is in recovery mode

Checks:

- `pg_isready`
- `SELECT pg_is_in_recovery();`

### `check_replication.sh`

Purpose:

- Confirm streaming replication is working
- Check primary-side replication status
- Check replica-side WAL receiver status
- Report replication lag when available

Checks:

- `pg_stat_replication`
- `pg_stat_wal_receiver`
- recovery mode
- lag fields

### `check_backups.sh`

Purpose:

- Confirm backup files exist
- Confirm latest backup is recent
- Confirm backup file size is not suspiciously small
- Prepare for restore validation checks

Checks:

- backup directory exists
- latest backup file exists
- latest backup age
- backup size

### `check_prometheus.sh`

Purpose:

- Confirm Prometheus is running
- Confirm Prometheus is reachable
- Confirm Prometheus targets are up

Checks:

- Prometheus service status
- Prometheus readiness endpoint
- Prometheus targets API

### `check_grafana.sh`

Purpose:

- Confirm Grafana is running
- Confirm Grafana web interface is reachable
- Confirm dashboard monitoring is available

Checks:

- Grafana service status
- Grafana HTTP response
- dashboard existence, when API credentials are configured

### `check_system_resources.sh`

Purpose:

- Confirm system resources are healthy
- Report disk, memory, CPU, and uptime

Checks:

- `df -h`
- `free -h`
- `uptime`

### `daily_health_report.py`

Purpose:

- Run or collect the output from health-check scripts
- Summarize results in plain language
- Save a report file
- Optionally email the report

Report sections:

- Host reachability
- PostgreSQL connectivity
- PostgreSQL service health
- Replication health
- Backup health
- Prometheus health
- Grafana health
- System resources
- GitHub status
- Issues found
- Recommended next actions

## Planned Daily Health Report Format

The daily health report should be easy to read.

Example:

```text
PostgreSQL DBA Lab Daily Health Report

Date: YYYY-MM-DD
Generated by: db-ops
Reviewed with: Acer Nitro V / Odysseus

Overall Status: OK

Host Reachability:
- db-primary: OK
- db-replica: OK
- db-ops: OK

PostgreSQL Connectivity:
- db-primary PostgreSQL connection: OK
- db-replica PostgreSQL connection: OK

PostgreSQL Services:
- db-primary PostgreSQL service: OK
- db-replica PostgreSQL service: OK

Replication:
- Replica recovery mode: TRUE
- Primary replication state: streaming
- WAL receiver status: active
- Replication lag: acceptable

Backups:
- Latest backup found: YES
- Backup age: acceptable
- Backup file size: valid
- Restore validation: pending

Monitoring:
- Prometheus service: OK
- Prometheus targets: UP
- Grafana service: OK
- Grafana reachable: YES
- Grafana dashboard status: available

System Resources:
- Disk space: OK
- RAM usage: OK
- CPU load: OK
- Uptime: recorded

GitHub:
- Repository status: clean or changes detected

Issues Found:
- None

Recommended Next Actions:
- Continue monitoring
- Run restore validation if not completed recently
```

## Status Levels

The health report should use simple status levels.

| Status | Meaning |
|---|---|
| OK | Check passed |
| WARNING | Check passed partially or needs attention |
| CRITICAL | Check failed and needs action |
| UNKNOWN | Check could not be completed |

Examples:

| Situation | Status |
|---|---|
| PostgreSQL accepts connections | OK |
| Backup exists but is older than expected | WARNING |
| Replica is not in recovery mode | CRITICAL |
| Grafana API check cannot run because credentials are not configured | UNKNOWN |

## Email Delivery Plan

The daily health report should eventually be emailed to the user.

Possible email delivery methods:

| Method | Notes |
|---|---|
| Python `smtplib` | Good learning method for understanding SMTP |
| `msmtp` | Lightweight Linux mail sender |
| `mailutils` | Simple command-line email option |
| Gmail app password | Possible if Gmail is used |
| Proton Mail Bridge | Possible if Proton is used and the bridge is configured |

Email delivery should not be implemented until the local report generation works reliably.

The first version should save reports locally. Email should be added after the report format is stable.

## Scheduling Plan

Scheduled automation should run from `db-ops` using `cron`.

Example schedule:

```cron
0 8 * * * /home/floren/postgresql-dba-home-lab/scripts/reports/daily_health_report.py
```

This means:

- Run every day
- At 8:00 AM
- From the `db-ops` server

Before scheduling with cron, each script should be tested manually.

## Logging Plan

Automation scripts should write logs so failures can be reviewed later.

Planned log folders:

```text
logs/
  health/
  reports/
```

Possible log examples:

```text
logs/health/check_replication_YYYY-MM-DD.log
logs/reports/daily_health_report_YYYY-MM-DD.txt
```

Logs should include:

- Date and time
- Host checked
- Command run
- Result
- Error message, if any
- Final status

## Security and Credential Handling

The lab should avoid hardcoding passwords directly inside scripts.

Preferred approaches:

- Use environment variables
- Use PostgreSQL `.pgpass` file for `psql` authentication
- Use limited-permission users where possible
- Keep secrets out of GitHub
- Document required secrets without committing the secret values

Files that may contain secrets should not be committed.

Example `.gitignore` entries to consider later:

```gitignore
.env
*.secret
.pgpass
logs/
```

The `logs/` folder may be committed as an empty structure later, but routine log output should usually not be committed.

## Implementation Phases

### Phase 1: Documentation

Goal:

- Define the automation architecture
- Document the role of the Acer Nitro V
- Document the role of `db-ops`
- Define the health report scope

Deliverables:

- `docs/ai-operations-workstation.md`
- `docs/automation-plan.md`

Acceptance criteria:

- Documentation is committed and pushed to GitHub
- The lab topology is clearly described
- Health report scope is documented

### Phase 2: Manual Health Checks

Goal:

- Create simple scripts that can be run manually from `db-ops`

Deliverables:

- `scripts/health/check_host_reachability.sh`
- `scripts/health/check_db_primary.sh`
- `scripts/health/check_db_replica.sh`
- `scripts/health/check_replication.sh`

Acceptance criteria:

- Each script runs manually
- Each script returns clear output
- Each script can report OK, WARNING, CRITICAL, or UNKNOWN

### Phase 3: Backup and Validation Checks

Goal:

- Add backup validation checks
- Confirm backup existence, age, and file size
- Prepare for restore validation

Deliverables:

- `scripts/health/check_backups.sh`
- backup status section in the daily report

Acceptance criteria:

- Script detects whether a backup exists
- Script identifies whether the backup appears valid
- Script reports if restore validation is pending

### Phase 4: Monitoring Checks

Goal:

- Add Prometheus and Grafana checks

Deliverables:

- `scripts/health/check_prometheus.sh`
- `scripts/health/check_grafana.sh`
- monitoring section in the daily report

Acceptance criteria:

- Prometheus service status can be checked
- Prometheus targets can be checked
- Grafana service status can be checked
- Grafana reachability can be checked

### Phase 5: Daily Report Generation

Goal:

- Combine all checks into a readable daily health report

Deliverables:

- `scripts/reports/daily_health_report.py`
- saved report files under `logs/reports/`

Acceptance criteria:

- Report runs manually
- Report includes all major health sections
- Report clearly lists issues and recommended next actions

### Phase 6: Email Delivery

Goal:

- Send the health report by email

Deliverables:

- email configuration documentation
- email sending function in the report script
- successful test email

Acceptance criteria:

- Report can be emailed manually
- Email does not expose secrets
- Email contains readable health summary

### Phase 7: Scheduling

Goal:

- Schedule the health report to run automatically

Deliverables:

- cron entry on `db-ops`
- scheduling documentation
- daily generated report

Acceptance criteria:

- Report runs automatically
- Report is saved to logs
- Email delivery works, if configured
- Failures are logged

### Phase 8: AI Review Workflow

Goal:

- Use the Acer Nitro V and Odysseus to review report output

Deliverables:

- process for copying report output into Odysseus
- AI-assisted troubleshooting notes
- GitHub documentation updates based on recurring issues

Acceptance criteria:

- Odysseus can help explain failed checks
- Troubleshooting notes are documented
- GitHub documentation improves over time

## DBA Skills Practiced

This automation plan supports learning the following DBA-relevant skills:

- PostgreSQL administration
- PostgreSQL connectivity checks
- PostgreSQL service monitoring
- Streaming replication validation
- Backup verification
- Restore readiness
- SQL diagnostics
- Linux Bash scripting
- Python scripting
- Cron scheduling
- Prometheus monitoring
- Grafana dashboard validation
- Linux system resource monitoring
- SSH-based administration
- Git and GitHub workflow
- Technical documentation
- Incident-style reporting
- AI-assisted operations workflows

## Learning Workflow

For each automation task, follow this workflow:

1. Define the purpose of the check.
2. Identify the command or SQL query needed.
3. Run the command manually.
4. Confirm the output.
5. Turn the command into a script.
6. Add error handling.
7. Save output to a log.
8. Add the result to the daily report.
9. Document what the script does.
10. Commit and push the change to GitHub.

This workflow ensures that automation is built gradually and understood clearly.

## First Implementation Target

The first automation target should be host and database connectivity.

Initial script:

```text
scripts/health/check_host_reachability.sh
```

This script should check:

- `db-primary`
- `db-replica`
- `db-ops`

Second script:

```text
scripts/health/check_db_connectivity.sh
```

This script should check:

- `pg_isready` for `db-primary`
- `pg_isready` for `db-replica`
- basic `psql` connection to `dba_lab`

These checks are the correct starting point because all later automation depends on basic network and database connectivity.

## Current Status

Current status:

- Acer Nitro V local AI workstation is configured
- Odysseus is working
- Ollama is working
- `qwen2.5-coder:14b` is installed and responding
- GitHub repository is cloned on the Acer
- AI operations workstation documentation has been created
- Automation plan documentation is being created

Next step:

- Create the planned script folders
- Create the first health-check script
- Test the first check manually before scheduling anything

## Summary

The DBA lab automation system should use the Acer Nitro V as an AI-assisted operations workstation and `db-ops` as the actual automation and monitoring server.

The Acer helps design, review, document, and troubleshoot the automation.

The `db-ops` server runs the scheduled checks, Prometheus, Grafana, reports, and email delivery.

This separation creates a realistic DBA learning environment and supports portfolio-ready documentation of monitoring, replication validation, backup verification, automation, and AI-assisted operations.