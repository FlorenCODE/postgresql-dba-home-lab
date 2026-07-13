# PostgreSQL DBA Home Lab

A hands-on, multi-system PostgreSQL database administration portfolio environment focused on PostgreSQL operations, Linux and Windows administration, streaming replication, Bash automation, troubleshooting, technical documentation, source control, and AI-assisted workflows.

This repository documents completed work, current implementation status, operational lessons, and future milestones. It is a controlled home-lab and portfolio environment that uses production-style role separation without being presented as a production system.

---

## Portfolio Summary

I built this PostgreSQL DBA home lab to develop practical experience across the responsibilities commonly associated with database administration, systems administration, monitoring, automation, and technical operations.

The environment currently includes:

- A writable PostgreSQL primary server
- A PostgreSQL streaming replica
- A dedicated operations and automation server
- A Windows 11 Pro Hyper-V virtualization host
- A separate AI operations and development workstation
- Four completed Bash health-check scripts
- A documented replication troubleshooting incident
- Git- and GitHub-based change control
- Repository-aware development support through GitHub Copilot
- A local AI environment using Docker, Odysseus, Ollama, and Qwen coding models
- Public-safe documentation, validation evidence, and portfolio milestones

The project demonstrates that the lab components can be installed, configured, validated, monitored, troubleshot, automated, documented, and improved through a repeatable operational workflow.

---

## Purpose and Learning Objectives

The primary purpose of this lab is to practice the technical responsibilities and work habits of a database administrator.

Key learning objectives include:

- Install and administer PostgreSQL
- Design and document relational database structures
- Manage databases, roles, schemas, tables, constraints, indexes, and views
- Configure and validate PostgreSQL streaming replication
- Diagnose replication failures
- Use PostgreSQL system views for operational validation
- Administer Ubuntu Server systems
- Manage Windows Hyper-V virtual machines
- Use PowerShell and SSH for cross-platform administration
- Automate health checks with Bash
- Validate disk, memory, CPU load, uptime, connectivity, and replication state
- Separate database, operations, monitoring, and administrator-workstation responsibilities
- Use Git branches, staged changes, diffs, commits, and GitHub
- Use hosted and local AI tools as reviewed assistants
- Document completed work separately from planned work
- Build evidence suitable for a technical portfolio

---

## Current Implementation Status

| Area | Status | Summary |
|---|---|---|
| PostgreSQL primary server | Completed | Writable PostgreSQL 18.x primary is operational |
| PostgreSQL replica server | Completed | Streaming replica is operational and validated |
| Database and schema design | Completed | Application, audit, security, reporting, and administration structures are documented |
| Replication validation | Completed | Recovery state, WAL receiver, primary streaming state, replay delay, and heartbeat propagation were checked |
| Replication troubleshooting | Completed | A hostname-resolution failure was diagnosed, corrected, and documented |
| Host reachability automation | Completed | Core lab systems can be checked from `db-ops` |
| Database connectivity automation | Completed | PostgreSQL readiness can be checked on the primary and replica |
| Replication health automation | Completed | Primary, replica, WAL receiver, heartbeat, and replay-delay checks are implemented |
| System-resource automation | Completed | Disk, memory, CPU-normalized load, and uptime checks are implemented and validated |
| AI operations workstation | Completed | Acer Nitro V runs local AI, development, and repository-management tooling |
| Git and GitHub workflow | Completed | Branch-based editing, review, commit, and push workflow is in use |
| Backup validation | In progress | Backup and restore validation workflows are being designed |
| Automated reporting | In progress | Report generation and scheduling are planned for `db-ops` |
| Windows Server learning | In progress | Windows administration and virtualization practice are continuing |
| Prometheus and Grafana | Planned | Monitoring and visualization are future milestones |
| Cron scheduling | Planned | Health scripts currently run manually and will later be scheduled |

---

## Current Architecture

The lab separates database services, operations automation, virtualization, AI-assisted development, and source control.

```text
Acer Nitro V
AI operations and development workstation
├── VS Code
├── GitHub Copilot
├── Git and GitHub
├── PowerShell
├── OpenSSH
├── Docker Desktop
├── Docker Compose
├── Odysseus
├── Ollama
├── qwen2.5-coder:14b
└── qwen2.5-coder:7b
          │
          │ edit, review, commit, push, and pull
          ▼
GitHub
├── Source control
├── Documentation
├── Health-check scripts
├── Portfolio history
└── Branch and change-review workflow
          │
          │ approved repository updates
          ▼
HP Envy
Windows 11 Pro Hyper-V host
├── db-primary
│   ├── Ubuntu Server virtual machine
│   ├── PostgreSQL primary server
│   ├── Writable database workload
│   └── WAL replication source
│          │
│          │ PostgreSQL WAL streaming
│          ▼
│   db-replica
│   ├── Separate bare-metal Ubuntu Server desktop
│   ├── PostgreSQL streaming replica
│   └── Read-only standby role
│
└── db-ops
    ├── Ubuntu Server virtual machine
    ├── Health-check execution
    ├── Automation validation
    ├── Operational logging
    └── Future scheduling and reporting
```

Private network addresses are intentionally excluded from the public documentation.

---

## Systems and Workstation Roles

### HP Envy

The HP Envy is the main Windows virtualization and infrastructure-administration host.

| Item | Current Role |
|---|---|
| Operating system | Windows 11 Pro |
| Virtualization | Hyper-V |
| Hosted systems | `db-primary` and `db-ops` Ubuntu Server virtual machines |
| Database administration | pgAdmin 4, PostgreSQL administration, SQL review |
| Windows administration | PowerShell, Hyper-V management, networking, VM management |
| Remote administration | OpenSSH and SSH |
| Additional learning | Windows Server administration and virtualization practice |

The HP Envy remains focused on hosting and administering the core lab infrastructure.

### Acer Nitro V

The Acer Nitro V is the AI operations, development, documentation, and repository-management workstation.

| Component | Current Configuration |
|---|---|
| Operating system | Windows 11 |
| Processor | Intel Core i7-13620H |
| Graphics | NVIDIA RTX 4050 Laptop GPU |
| Memory | 64 GB DDR5 |
| Development environment | VS Code |
| AI coding assistant | GitHub Copilot |
| Hosted AI workspace | Odysseus in Docker |
| Local model server | Ollama |
| Main local model | `qwen2.5-coder:14b` |
| Faster fallback model | `qwen2.5-coder:7b` |
| Container platform | Docker Desktop and Docker Compose |
| WSL usage | WSL 2 infrastructure currently provided through Docker Desktop |
| Source control | Git and GitHub |
| Windows shell | PowerShell |
| Remote administration | OpenSSH and SSH |

The Acer is not used as the PostgreSQL primary, replica, or operations server. It acts as a separate administrator and AI-assisted development workstation.

### `db-primary`

`db-primary` is the writable PostgreSQL server.

| Item | Current Value |
|---|---|
| Platform | Ubuntu Server virtual machine |
| Database engine | PostgreSQL 18.x |
| Role | Primary PostgreSQL server |
| Main database | `dba_lab` |
| Administrative lab role | `dbadmin` |
| Replication function | WAL source for `db-replica` |

### `db-replica`

`db-replica` is the PostgreSQL standby server.

| Item | Current Value |
|---|---|
| Platform | Bare-metal Ubuntu Server |
| Role | PostgreSQL streaming replica |
| Access model | Read-only standby |
| Recovery state | Verified |
| WAL receiver | Verified as streaming |
| Primary-side streaming state | Verified |
| Heartbeat replication | Verified |
| Replay-delay review | Completed |

### `db-ops`

`db-ops` is the operations, automation, monitoring, logging, and reporting server.

| Item | Current Role |
|---|---|
| Platform | Ubuntu Server virtual machine |
| Current use | Manual execution of validated health-check scripts |
| Automation | Host, PostgreSQL, replication, and system-resource checks |
| Logging | Health-check output and validation logs |
| Future use | Cron, reports, backup validation, Prometheus, Grafana, and report delivery |

---

## Current PostgreSQL Environment

| Item | Current Value |
|---|---|
| PostgreSQL version | PostgreSQL 18.x |
| Main database | `dba_lab` |
| Administrative lab role | `dbadmin` |
| Primary server | `db-primary` |
| Replica server | `db-replica` |
| Operations server | `db-ops` |
| Database administration tool | pgAdmin 4 |
| Replication model | Asynchronous physical streaming replication |

Current schemas include:

- `app`
- `audit`
- `security`
- `reporting`
- `lab_admin`

The application design includes relational structures for:

- Assessment sessions
- Student responses
- Understanding reports
- Instructor review
- Reporting and educational analytics
- Replication heartbeat validation

The lab also includes practice with:

- Primary keys
- Foreign keys
- Unique constraints
- Check constraints
- Identity columns
- Indexes
- Views
- Schema organization
- Role and permission concepts
- Metadata queries
- Seed data
- Database evidence collection

---

## Completed Database and Schema Work

Completed database-design work includes:

- Created the `dba_lab` database
- Created the `dbadmin` administrative lab role
- Created application, audit, security, reporting, and lab-administration schemas
- Designed normalized relational tables
- Added primary keys and foreign keys
- Added unique and check constraints
- Added identity columns and indexes
- Created reporting and metadata-query workflows
- Created database-design and seed-data checkpoints
- Connected to the primary and replica with pgAdmin 4
- Collected public-safe screenshots and documentation

The application schema supports the Student Understanding Verification Platform portfolio project and related educational analytics workflows.

---

## Streaming Replication

Streaming replication between `db-primary` and `db-replica` has been implemented and validated.

Validation included:

- Confirming `db-primary` is not in recovery mode
- Confirming `db-replica` is in recovery mode
- Querying `pg_stat_replication` on the primary
- Querying `pg_stat_wal_receiver` on the replica
- Confirming the WAL receiver is streaming
- Confirming the primary sees the replica connection
- Reviewing replication replay delay
- Inserting a live heartbeat row on the primary
- Confirming the heartbeat row appeared on the replica

Useful PostgreSQL validation queries include:

```sql
SELECT pg_is_in_recovery();
```

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

```sql
SELECT
    status,
    sender_host,
    sender_port,
    latest_end_lsn,
    latest_end_time
FROM pg_stat_wal_receiver;
```

Detailed replication evidence is available in the [streaming replication checkpoint](docs/05_replication_high_availability/streaming_replication_checkpoint.md).

---

## Replication Troubleshooting Incident

A real replication incident occurred during automation testing.

The initial high-level checks passed:

- Host reachability
- PostgreSQL connectivity

However, deeper validation showed that the replica was not actively streaming.

The issue was traced to an outdated hostname mapping on `db-replica`. After correcting hostname resolution and restarting PostgreSQL on the replica:

- The WAL receiver resumed streaming
- The primary detected the replica connection
- The heartbeat test succeeded
- Replication returned to an acceptable state

This incident demonstrated that basic network and port connectivity are not enough to prove replication health. Recovery state, WAL receiver state, primary-side streaming status, replay delay, and live data propagation must also be checked.

Detailed documentation is available in the [replication troubleshooting report](docs/replication-troubleshooting.md).

---

## Health-Check Automation

The repository currently includes four completed Bash health-check scripts.

| Script | Status | Purpose | Principal Checks | Run Location |
|---|---|---|---|---|
| `scripts/health/check_host_reachability.sh` | Completed | Confirm basic network reachability | Checks the core lab hosts with network probes | `db-ops` |
| `scripts/health/check_db_connectivity.sh` | Completed | Confirm PostgreSQL availability | Uses `pg_isready` against the primary and replica | `db-ops` |
| `scripts/health/check_replication.sh` | Completed | Validate streaming replication | Recovery roles, primary streaming state, WAL receiver, heartbeat replication, and replay delay | `db-ops` |
| `scripts/health/check_system_resources.sh` | Completed and validated | Check operating-system resources | Root disk usage, memory usage, CPU-normalized load, and uptime | `db-ops` |

### Host Reachability Check

The host-reachability script:

- Checks whether the core lab systems respond over the network
- Provides a basic prerequisite check before deeper database validation
- Returns `OK` when all hosts are reachable
- Returns `CRITICAL` when a required host cannot be reached

### PostgreSQL Connectivity Check

The database-connectivity script:

- Uses `pg_isready`
- Checks PostgreSQL readiness on the primary and replica
- Confirms the servers are listening on the PostgreSQL port
- Does not authenticate into the database
- Returns `OK` or `CRITICAL`

### Replication Health Check

The replication-health script validates:

- The primary is not in recovery mode
- The replica is in recovery mode
- The primary sees at least one streaming replica
- The replica WAL receiver is streaming
- A live heartbeat row propagates from primary to replica
- Replay delay is within an acceptable range

The script returns `OK`, `WARNING`, or `CRITICAL`.

### System-Resource Health Check

The system-resource script validates:

- Root filesystem utilization
- Memory utilization
- One-minute load average
- Load normalized to the number of logical CPUs
- System uptime

The script was validated directly on `db-ops`.

Validation confirmed:

- Bash syntax validation passed
- The correct host was reported
- Root filesystem usage was calculated
- Memory usage was calculated
- CPU-normalized load was calculated
- Uptime was reported
- The final status was `OK`
- The script returned exit code `0`

Observed values during the validation run were approximately:

| Measurement | Observed Result |
|---|---|
| Root filesystem usage | 53% |
| Memory usage | 22% |
| Logical CPUs | 4 |
| One-minute load average | 0.09 |
| CPU-normalized load | 2% |
| Overall status | `OK` |
| Exit code | `0` |

The script uses stricter Bash error handling:

```bash
set -euo pipefail
```

This helps detect unexpected command failures, undefined variables, and failures inside pipelines.

The repository also includes a `.gitattributes` rule that keeps shell scripts in Linux-compatible LF format:

```gitattributes
*.sh text eol=lf
```

---

## Exit-Code Behavior

The health scripts use exit codes to communicate their final result.

| Exit Code | Meaning |
|---:|---|
| `0` | OK |
| `1` | WARNING, when supported by the script |
| `2` | CRITICAL |

Current behavior by script:

| Script | Supported Final States |
|---|---|
| `check_host_reachability.sh` | OK or CRITICAL |
| `check_db_connectivity.sh` | OK or CRITICAL |
| `check_replication.sh` | OK, WARNING, or CRITICAL |
| `check_system_resources.sh` | OK, WARNING, or CRITICAL |

Future cron jobs, report generators, or wrapper scripts must deliberately capture these exit codes rather than treating every nonzero result identically.

---

## AI Operations Workstation

The Acer Nitro V provides a separate AI-assisted environment for planning, reviewing, documenting, and troubleshooting the DBA lab.

### Local AI Architecture

```text
Odysseus in Docker
        │
        │ OpenAI-compatible local endpoint
        ▼
http://host.docker.internal:11434/v1
        │
        ▼
Ollama on the Acer
        │
        ├── qwen2.5-coder:14b
        └── qwen2.5-coder:7b
```

The `qwen2.5-coder:14b` model successfully responded to a PostgreSQL replication diagnostic prompt and identified relevant checks such as:

```sql
SELECT pg_is_in_recovery();
```

and:

```sql
SELECT *
FROM pg_stat_wal_receiver;
```

During local-model testing, GPU utilization reached approximately 82%, confirming that the Acer can run the 14B coding model as a practical local assistant.

---

## AI-Assisted Development Workflow

The lab uses hosted and local AI tools for different purposes.

| Tool | Role |
|---|---|
| GitHub Copilot in VS Code | Repository-aware editing, documentation updates, code review, and multi-file assistance |
| ChatGPT | Planning, technical explanation, troubleshooting strategy, validation steps, and review |
| Odysseus | Local AI workspace and model interface |
| Ollama | Local model server |
| Qwen coding models | Local SQL, Bash, documentation, and troubleshooting assistance |

AI-generated output is not automatically trusted.

The review process includes:

1. Inspecting the actual repository files
2. Reviewing generated commands and scripts
3. Checking Git diffs
4. Running formatting and syntax validation
5. Testing scripts manually on the intended server
6. Confirming exit codes and output
7. Committing only after successful review

This workflow keeps AI assistance separate from operational execution and preserves human review.

---

## Two-Laptop Workflow

The lab separates development and infrastructure responsibilities across the Acer Nitro V and HP Envy.

### Acer Nitro V Responsibilities

- Open and edit the Git repository
- Use VS Code and GitHub Copilot
- Use ChatGPT for planning and validation
- Use Odysseus and Ollama for local AI-assisted work
- Review SQL and Bash scripts
- Write and improve documentation
- Create and use Git branches
- Review staged and unstaged diffs
- Commit and push approved changes
- Develop portfolio material

### HP Envy Responsibilities

- Run Hyper-V
- Host `db-primary` and `db-ops`
- Manage Ubuntu Server virtual machines
- Administer PostgreSQL through pgAdmin and SSH
- Practice PowerShell and Windows administration
- Troubleshoot VM networking and connectivity
- Support Windows Server learning

### `db-ops` Responsibilities

- Pull approved repository changes
- Run health-check scripts
- Validate automation behavior
- Store operational logs
- Eventually run scheduled checks and reports

This separation prevents the AI workstation from replacing the actual database and operations infrastructure.

---

## Git and GitHub Workflow

GitHub acts as the central source-control and portfolio platform.

```text
Acer Nitro V
    │
    ├── create or switch to a feature branch
    ├── edit documentation and scripts
    ├── review changes with Git diffs
    ├── validate syntax and behavior
    ├── commit approved changes
    └── push the feature branch
            │
            ▼
         GitHub
            │
            ├── repository history
            ├── documentation
            ├── scripts
            └── portfolio evidence
                    │
                    ▼
                 db-ops
                    └── pull approved changes and run scripts
```

The workflow demonstrates:

- Branch-based development
- Staged and unstaged change review
- Commit discipline
- Remote repository management
- Public-safe documentation
- AI-assisted but human-reviewed development

---

## Technologies and Tools

### Database and SQL

- PostgreSQL 18.x
- SQL
- pgAdmin 4
- Relational database design
- PostgreSQL system views
- Streaming replication
- Write-ahead logging concepts
- Role and permission concepts

### Linux and Automation

- Ubuntu Server
- Bash
- `psql`
- `pg_isready`
- `systemctl`
- `journalctl`
- SSH
- Cron concepts
- Linux resource monitoring
- Linux hostname resolution

### Windows and Virtualization

- Windows 11 Pro
- Hyper-V
- PowerShell
- OpenSSH
- Windows networking
- Virtual-machine administration
- Windows Server learning

### Development and Source Control

- Visual Studio Code
- Git
- GitHub
- GitHub Copilot
- Markdown
- Branch-based workflows
- Diff review
- Technical documentation

### Containers and AI

- Docker Desktop
- Docker Compose
- WSL 2 infrastructure
- Odysseus
- Ollama
- `qwen2.5-coder:14b`
- `qwen2.5-coder:7b`
- ChatGPT
- Local and hosted AI-assisted workflows

### Planned Monitoring Tools

The following tools are part of the planned monitoring roadmap and are not yet documented as completed implementations:

- Prometheus
- Grafana
- Node Exporter
- PostgreSQL Exporter

---

## Skills Demonstrated

This portfolio currently demonstrates practical experience with:

- PostgreSQL installation and administration
- SQL diagnostics
- Relational schema design
- Primary and replica architecture
- Physical streaming replication
- Recovery-mode validation
- WAL receiver analysis
- Primary-side replication analysis
- Replication replay-delay review
- Live replication heartbeat testing
- Linux service administration
- Linux hostname-resolution troubleshooting
- Bash scripting
- Health-check design
- Exit-code handling
- Disk and memory monitoring
- CPU-load normalization
- Windows Hyper-V administration
- SSH-based remote administration
- Git and GitHub workflows
- GitHub Copilot-assisted development
- Local LLM operation
- AI-assisted code and documentation review
- Incident documentation
- Public-safe technical writing
- Separating completed work from planned work

---

## Repository Structure

```text
postgresql-dba-home-lab/
├── README.md
├── PUBLICATION_CHECKLIST.md
├── .gitattributes
├── .gitignore
│
├── docs/
│   ├── 01-lab-overview.md
│   ├── 02-environment-and-tools.md
│   ├── 03-postgresql-installation-and-configuration.md
│   ├── 04-database-schema-design.md
│   ├── 05-backup-and-recovery-evidence.md
│   ├── 06-evidence-collection-method.md
│   ├── 07-lessons-learned.md
│   ├── 08-next-steps.md
│   ├── ai-operations-workstation.md
│   ├── automation-plan.md
│   ├── automation-status.md
│   ├── replication-troubleshooting.md
│   ├── 02_database_design/
│   │   └── suvp_schema_seed_data_checkpoint.md
│   ├── 05_replication_high_availability/
│   │   └── streaming_replication_checkpoint.md
│   └── progress/
│       └── 2026-07-ai-automation-milestone.md
│
├── scripts/
│   ├── health/
│   │   ├── check_host_reachability.sh
│   │   ├── check_db_connectivity.sh
│   │   ├── check_replication.sh
│   │   └── check_system_resources.sh
│   └── reports/
│
├── sql/
└── screenshots/
```

---

## Documentation Index

### Core Documentation

| Document | Purpose |
|---|---|
| [Lab overview](docs/01-lab-overview.md) | Current architecture, objectives, milestones, and operating model |
| [Environment and tools](docs/02-environment-and-tools.md) | Hardware, operating systems, software, and system roles |
| [PostgreSQL installation and configuration](docs/03-postgresql-installation-and-configuration.md) | PostgreSQL setup and configuration work |
| [Database schema design](docs/04-database-schema-design.md) | Database architecture, tables, constraints, and schema design |
| [Backup and recovery evidence](docs/05-backup-and-recovery-evidence.md) | Backup and recovery planning documentation |
| [Evidence collection method](docs/06-evidence-collection-method.md) | Public-safe technical evidence practices |
| [Lessons learned](docs/07-lessons-learned.md) | Technical and operational lessons from the lab |
| [Next steps](docs/08-next-steps.md) | Planned future milestones |

### Replication and Automation

| Document | Purpose |
|---|---|
| [Streaming replication checkpoint](docs/05_replication_high_availability/streaming_replication_checkpoint.md) | Evidence and validation of the primary and replica configuration |
| [Replication troubleshooting](docs/replication-troubleshooting.md) | Root cause, repair, and validation of a replication failure |
| [Automation plan](docs/automation-plan.md) | Long-term roadmap for health checks, reporting, monitoring, and scheduling |
| [Automation status](docs/automation-status.md) | Current completed, in-progress, and planned automation work |

### AI and Progress Documentation

| Document | Purpose |
|---|---|
| [AI operations workstation](docs/ai-operations-workstation.md) | Acer Nitro V, Docker, Odysseus, Ollama, Qwen, and AI-assisted workflows |
| [July 2026 AI and automation milestone](docs/progress/2026-07-ai-automation-milestone.md) | Portfolio milestone covering replication, automation, and AI progress |
| [SUVP schema and seed-data checkpoint](docs/02_database_design/suvp_schema_seed_data_checkpoint.md) | Database-design checkpoint for the application schema |
| [Publication checklist](PUBLICATION_CHECKLIST.md) | Public-repository and portfolio-readiness review |

---

## Completed, In Progress, and Planned Work

### Completed

- PostgreSQL 18.x primary environment
- `dba_lab` database
- `dbadmin` administrative lab role
- Application, audit, security, reporting, and lab-administration schemas
- Relational database design
- Constraints and indexes
- pgAdmin administration workflow
- PostgreSQL streaming replication
- Primary and replica role validation
- Primary-side replication validation
- WAL receiver validation
- Live heartbeat replication test
- Replication replay-delay review
- Replication hostname-resolution troubleshooting
- Host reachability health-check script
- PostgreSQL connectivity health-check script
- Replication health-check script
- System-resource health-check script
- System-resource validation on `db-ops`
- Local AI workstation
- Local Qwen model validation
- GitHub Copilot workflow
- Git and GitHub repository workflow
- Public-safe documentation workflow

### In Progress

- Backup validation design
- Restore-testing preparation
- Health-report generation
- Scheduling design
- Log-management planning
- Prometheus and Grafana integration planning
- Windows Server administration practice
- Additional screenshots and portfolio evidence
- Continued documentation refinement

### Planned

- Cron-based health-check scheduling
- Log rotation
- Automated daily DBA health reports
- Automated report delivery
- PostgreSQL backup validation
- PostgreSQL restore validation
- Prometheus metrics collection
- Grafana dashboards
- Broader alerting and monitoring
- Additional system-resource checks
- Additional data-validation checks
- Failover and recovery exercises
- Read-only routing practice

---

## Planned Next Work

The next major phase of the lab will focus on:

1. Building a PostgreSQL backup-validation check
2. Testing PostgreSQL restore procedures
3. Creating a combined daily health-report generator
4. Capturing individual script exit codes safely
5. Scheduling validated checks on `db-ops`
6. Implementing log rotation
7. Adding Prometheus metrics collection
8. Adding Grafana visualization
9. Documenting Windows Server administration exercises
10. Expanding incident-response and recovery documentation

These items remain planned or in progress and are not presented as completed implementations.

---

## Public-Safety and Scope Statement

This repository is a public portfolio version of a private home-lab environment.

The public documentation intentionally excludes:

- Private network addresses
- Passwords
- API keys
- Authentication tokens
- Private SSH keys
- Credential files
- Sensitive configuration
- Unnecessary raw logs
- Personally sensitive system information

Environment-specific values may still be required inside operational scripts, but public documentation uses logical hostnames and system roles wherever possible.

This project is not presented as a production environment. It is a controlled PostgreSQL DBA home lab that uses production-style role separation, simulated operations, repeatable validation, and evidence-backed learning.

---

## Portfolio Conclusion

This project has progressed from a basic PostgreSQL virtual machine into a multi-system DBA learning environment with a writable primary, a streaming replica, an operations server, a separate AI workstation, four completed health-check scripts, documented troubleshooting evidence, and a disciplined GitHub workflow.

The lab demonstrates not only that PostgreSQL components can be installed, but that they can be validated, monitored, troubleshot, automated, documented, and improved through a structured operational process.