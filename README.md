# PostgreSQL DBA Home Lab Portfolio

This repository documents a public-safe, in-progress PostgreSQL DBA home lab built for hands-on database administration practice. The lab runs on a private local network and is not a production deployment.

The purpose of this project is to demonstrate practical DBA skills through a working PostgreSQL environment with primary/replica architecture, schema design, synthetic data, backup and restore validation, an operations server, and professional documentation.

## Project Status

**Current major checkpoint:** working PostgreSQL primary/replica environment with a dedicated operations server and a validated manual backup-and-restore workflow.

The lab currently includes:

- PostgreSQL 18.4 primary server.
- PostgreSQL 18.4 read-only streaming replica.
- Dedicated `db-ops` operations server.
- Student Understanding Verification Platform-compatible database model.
- Synthetic seed data.
- Streaming replication validation.
- Manual backup with `pg_dump`.
- Restore validation with `pg_restore`.
- Portfolio evidence through screenshots, logs, SQL scripts, and documentation.

## Lab Architecture

```text
Windows 11 Pro / Hyper-V Host
│
├── db-primary
│   └── PostgreSQL primary write server
│
├── db-replica
│   └── PostgreSQL read-only streaming replica
│
└── db-ops
    └── Operations server for backups, cron jobs, monitoring checks, scripts, and logs
```

## Current SQL Servers

| Server | Role |
|---|---|
| `db-primary` | Main PostgreSQL write server |
| `db-replica` | PostgreSQL read-only streaming replica |
| `db-ops` | Operations server for backups, cron jobs, monitoring, scripts, and logs |

## Core Database

| Item | Value |
|---|---|
| Database | `dba_lab` |
| PostgreSQL version | PostgreSQL 18.4 |
| Main administrative role | `dbadmin` |
| Primary server role | Read/write |
| Replica server role | Read-only standby |
| Operations server role | Backup, restore testing, monitoring, scheduled jobs, and scripts |

## Database Schemas

The lab database is organized into separate schemas to practice real database object organization.

| Schema | Purpose |
|---|---|
| `app` | Application tables for the student-understanding assessment model |
| `audit` | Audit/event tracking |
| `security` | Role-based access control practice |
| `reporting` | Reporting views and review queries |
| `lab_admin` | Lab administration and replication validation objects |

## Completed Milestones

### PostgreSQL Environment

- Built a local PostgreSQL lab environment using virtualization.
- Installed and validated PostgreSQL 18.4 on Ubuntu Server.
- Created the `dba_lab` PostgreSQL database.
- Created and used PostgreSQL administrative roles for lab work.
- Connected to PostgreSQL using `psql`.
- Connected to PostgreSQL using pgAdmin 4.
- Practiced command-line administration from both Windows PowerShell and Ubuntu Server.

### Database Design

- Organized database objects into the following schemas:
  - `app`
  - `audit`
  - `security`
  - `reporting`
  - `lab_admin`
- Designed relational tables for a student-understanding assessment model.
- Documented primary keys, foreign keys, unique constraints, check constraints, and indexes.
- Created audit/event tracking tables.
- Created security and RBAC practice tables.
- Created reporting views for lab review queries.
- Exported ERD and selected public-safe screenshots.

### Application Data Model

The lab database supports a Student Understanding Verification Platform-style model.

Current model areas include:

- Instructors
- Students
- Courses
- Course enrollments
- Assessment sessions
- Student responses
- Understanding reports
- Audit events
- Application roles
- Application permissions
- Role-permission mappings
- User-role assignments
- Reporting views
- Replication heartbeat validation

### Seed Data and Validation

- Loaded synthetic instructors, students, courses, enrollments, assessment sessions, student responses, understanding reports, security roles, permissions, and audit events.
- Validated seed data on the primary server.
- Used SQL queries to verify table relationships and expected row counts.
- Confirmed seeded data replicated successfully to the replica server.
- Captured screenshot evidence for portfolio documentation.

### Streaming Replication

- Configured a separate PostgreSQL replica server for asynchronous streaming replication.
- Verified that `db-primary` is writable.
- Verified that `db-replica` is read-only.
- Confirmed replication using a heartbeat table and replicated test rows.
- Confirmed replica state using PostgreSQL recovery checks.
- Verified that the replica reports `pg_is_in_recovery() = true`.
- Documented the primary/replica checkpoint.

### Operations Server

- Built a dedicated `db-ops` Ubuntu Server VM.
- Installed PostgreSQL client tools, including:
  - `psql`
  - `pg_dump`
  - `pg_restore`
- Installed supporting operations tools:
  - `rsync`
  - `curl`
  - `wget`
  - `git`
  - `jq`
  - `tree`
  - `net-tools`
  - `dnsutils`
  - `netcat-openbsd`
  - `cron`
- Confirmed `db-ops` can reach both PostgreSQL servers over the network.
- Confirmed `db-ops` can authenticate to both `db-primary` and `db-replica`.
- Confirmed `cron` is enabled and running for future scheduled jobs.

### Backup and Restore Validation

- Created a backup folder structure under `/var/backups/dba-lab/`.
- Created a log folder under `/var/log/dba-lab/`.
- Performed a manual custom-format backup from `db-primary` using `pg_dump`.
- Verified the backup file using `pg_restore -l`.
- Created a timestamped restore-test database.
- Restored the backup into the restore-test database using `pg_restore`.
- Verified restored objects across the `app`, `audit`, `lab_admin`, `reporting`, and `security` schemas.
- Saved restore-test evidence in a timestamped log file.
- Confirmed that the backup was readable, restorable, and contained expected schema objects.

## Restore Validation Summary

A custom-format PostgreSQL backup was created from `db-primary`, restored into a separate restore-test database, and validated by querying restored schema objects.

Restore validation confirmed objects in the following schemas:

- `app`
- `audit`
- `lab_admin`
- `reporting`
- `security`

This demonstrates a core DBA principle:

> A backup is not trusted until it has been successfully restored and validated.

## Key Documentation

- [Streaming Replication Checkpoint](docs/05_replication_high_availability/streaming_replication_checkpoint.md)
- [SUVP Schema and Seed Data Checkpoint](docs/02_database_design/suvp_schema_seed_data_checkpoint.md)
- [Lab Overview](docs/01-lab-overview.md)
- [Environment and Tools](docs/02-environment-and-tools.md)
- [PostgreSQL Installation and Configuration](docs/03-postgresql-installation-and-configuration.md)
- [Database Schema Design](docs/04-database-schema-design.md)
- [Backup and Recovery Evidence](docs/05-backup-and-recovery-evidence.md)
- [Evidence Collection Method](docs/06-evidence-collection-method.md)
- [Lessons Learned](docs/07-lessons-learned.md)
- [Next Steps](docs/08-next-steps.md)

## SQL Scripts

- [SUVP Schema Seed Data Scripts](sql/05_suvp_schema_seed_data/)

Planned SQL script areas include:

- Schema creation scripts
- Seed data scripts
- Validation queries
- Reporting view definitions
- Backup and restore helper scripts
- Monitoring and health-check queries
- Role and permission management scripts
- Replication validation queries

## Screenshot Evidence

- [Replication Screenshots](screenshots/replication/)
- [SUVP Schema and Seed Data Screenshots](screenshots/suvp_schema_seed_data/)
- [Selected Screenshots](screenshots/)

Selected public-safe screenshot examples:

- [Lab schemas](screenshots/04_lab_schemas.png)
- [Application tables](screenshots/05_app_schema_tables.png)
- [Application column summary](screenshots/06b_app_table_column_summary.png)
- [Constraints and keys](screenshots/07_constraints_primary_foreign_keys.png)
- [Foreign key relationships](screenshots/08_foreign_key_relationships.png)
- [Indexes](screenshots/09_indexes.png)
- [Audit schema table](screenshots/10_audit_schema_tables.png)
- [Security schema tables](screenshots/12_security_schema_tables.png)
- [Reporting views](screenshots/13_reporting_schema_views.png)
- [Database object summary](screenshots/15_database_object_summary.png)
- [ERD screenshot](screenshots/17_erd_schema_diagram_app_schema_screenshot.png)
- [ERD zoomed-out screenshot](screenshots/17_erd_schema_diagram_app_schema_screenshot-zoomed-out.png)

## Skills Demonstrated

This lab demonstrates practical database administration skills, including:

- PostgreSQL installation and service validation
- Linux server administration basics
- SSH-based server access
- PostgreSQL role and database management
- Schema design and database object organization
- Primary key, foreign key, constraint, and index documentation
- Primary/replica PostgreSQL architecture
- Streaming replication validation
- Read-only standby verification
- SQL seed data design
- Relational joins and validation queries
- Audit/event data modeling
- Security and RBAC data modeling
- PostgreSQL metadata queries
- Backup creation with `pg_dump`
- Backup inspection with `pg_restore -l`
- Restore testing with `pg_restore`
- Operations server setup
- Cron readiness for scheduled jobs
- Evidence collection for a technical portfolio
- Git and GitHub documentation workflow
- Public-safe technical documentation

## Tools Used

- PostgreSQL 18.4
- Ubuntu Server
- Hyper-V
- pgAdmin 4
- Windows PowerShell
- SSH
- `psql`
- `pg_dump`
- `pg_restore`
- `rsync`
- `cron`
- `jq`
- `tree`
- `netcat-openbsd`
- Git and GitHub
- PostgreSQL metadata queries
- CSV exports
- ERD and screenshots

## Repository Safety Notes

This is a public-safe portfolio repository. Credentials, passwords, private keys, raw evidence files, sensitive configuration files, raw database backup archives, and private source evidence are intentionally excluded.

The repository should include:

- Documentation
- Sanitized screenshots
- Sanitized restore-test logs
- SQL schema scripts
- SQL validation queries
- Backup and monitoring scripts that do not contain credentials
- Public-safe portfolio explanations

The repository should not include:

- Raw `.dump` backup files
- Raw production-style SQL exports containing data
- `.env` files
- `.pgpass` files
- Passwords
- API keys
- Private keys
- Unredacted sensitive logs
- Raw database backup archives

Recommended `.gitignore` patterns include:

```gitignore
# Database backup/export files
*.dump
*.backup
*.tar
*.gz

# Sensitive environment/credential files
.env
.pgpass

# Backup/export folders
backups/
backup/
exports/
dumps/
restore-tests/

# Raw SQL exports only
*_backup.sql
*_dump.sql
*_export.sql
```

Clean SQL files used for schema design, migrations, and portfolio queries may be committed when they do not contain credentials or sensitive data.

## What Is In Progress

The lab is currently moving from manual operations into repeatable operations automation.

Current in-progress work includes:

- Converting manual backup commands into reusable scripts.
- Creating scheduled backups with `cron`.
- Creating backup success and failure logs.
- Adding backup retention cleanup logic.
- Documenting restore-test evidence in public-safe Markdown format.
- Creating monitoring and health-check scripts for `db-primary` and `db-replica`.
- Adding replication health checks from `db-ops`.
- Improving role separation for backup, monitoring, read-only, and application users.

## Next Planned Lab Additions

Planned next steps include:

- Create scheduled backups with `cron`.
- Create backup success/failure logs.
- Add backup retention cleanup logic.
- Add restore-test documentation.
- Practice PostgreSQL point-in-time recovery concepts.
- Add monitoring queries and health checks.
- Create scripts to check primary and replica availability.
- Create scripts to check replication health and replica recovery state.
- Add PostgreSQL log review notes.
- Practice indexing and query analysis.
- Practice role separation for backup, monitoring, read-only, and application users.
- Add Prometheus, Grafana, and PostgreSQL exporter after the backup and health-check workflow is documented.
- Practice failover and recovery documentation.

## Future Advanced Topics

Future expansion areas include:

- Point-in-time recovery
- WAL archiving
- Backup retention policies
- Monitoring dashboards
- Prometheus
- Grafana
- PostgreSQL exporter
- Linux node exporter
- Failover practice
- Recovery documentation
- Read-only reporting users
- Dedicated backup users
- Dedicated monitoring users
- Query performance analysis
- Index tuning
- Maintenance jobs
- Windows Server administration practice
- PowerShell automation

## LinkedIn-Ready Materials

- [LinkedIn Project Description](linkedin-project-description.md)
- [LinkedIn Progress Post](linkedin-progress-post.md)

## Publication Support

- [Publication Checklist](PUBLICATION_CHECKLIST.md)
- [Selected Screenshots](screenshots/)

## Professional Summary

This project demonstrates a hands-on PostgreSQL DBA learning environment with practical work in database installation, schema design, replication, backup validation, restore testing, Linux operations, and documentation.

The current milestone shows that the lab has moved beyond simple database creation and now includes operational DBA practices: a dedicated operations server, validated connectivity to both primary and replica databases, a successful custom-format backup, and a confirmed restore into a separate restore-test database.

This repository is actively maintained as a DBA learning and portfolio project.
