# PostgreSQL DBA Home Lab Portfolio

## Current Lab Status

This PostgreSQL DBA home lab currently demonstrates a working two-server PostgreSQL environment with primary-to-replica streaming replication, database inventory documentation, synthetic seed data, validation queries, and screenshot evidence.

### Completed Milestones

- Built a PostgreSQL 18.4 primary database server on Ubuntu Server.
- Configured a separate PostgreSQL replica server for asynchronous streaming replication.
- Verified that `db-primary` is writable and `db-replica` is read-only.
- Confirmed replication using a heartbeat table and replicated test rows.
- Built a Student Understanding Verification Platform-compatible database model.
- Loaded synthetic instructors, students, courses, enrollments, assessment sessions, student responses, understanding reports, security roles, permissions, and audit events.
- Validated seed data on the primary server.
- Confirmed seed data replicated successfully to the replica server.
- Captured screenshots and SQL scripts as portfolio evidence.

### Key Documentation

- [Streaming Replication Checkpoint](docs/05_replication_high_availability/streaming_replication_checkpoint.md)
- [SUVP Schema and Seed Data Checkpoint](docs/02_database_design/suvp_schema_seed_data_checkpoint.md)

### SQL Scripts

- [SUVP Schema Seed Data Scripts](sql/05_suvp_schema_seed_data/)

### Screenshot Evidence

- [Replication Screenshots](screenshots/replication/)
- [SUVP Schema and Seed Data Screenshots](screenshots/suvp_schema_seed_data/)

## Skills Demonstrated

This lab demonstrates practical database administration skills, including:

- PostgreSQL installation and service validation
- Role and database management
- Schema inspection and database inventory
- Primary/replica architecture
- Streaming replication validation
- Read-only standby verification
- SQL seed data design
- Relational joins and validation queries
- Audit/event data modeling
- Portfolio documentation using Git and GitHub

## Next Planned Work

Planned next steps include:

- Backup and restore workflow
- Point-in-time recovery practice
- Monitoring queries and health checks
- Automated maintenance scripts
- Failover practice and recovery documentation
- Additional documentation for DBA portfolio presentation




This is a public-safe, in-progress PostgreSQL DBA home lab portfolio. It documents hands-on database administration practice in a local learning environment, not a production deployment.

## Purpose

I built this lab to practice practical DBA skills: PostgreSQL setup, schema design, relational modeling, constraints, indexes, audit/security/reporting organization, backup and recovery planning, evidence collection, and professional documentation.

## Tools Used

- PostgreSQL
- Ubuntu Server
- Hyper-V
- pgAdmin 4
- Windows PowerShell
- SSH
- PostgreSQL metadata queries
- CSV exports
- Schema-only dump
- ERD and screenshots
- Backup and recovery planning tools

## Completed Milestones

- Built a local PostgreSQL lab environment using virtualization.
- Created a PostgreSQL lab database.
- Organized objects into `app`, `audit`, `security`, and `reporting` schemas.
- Designed relational tables for a student-understanding assessment model.
- Documented primary keys, foreign keys, unique constraints, check constraints, and indexes.
- Created audit and security/RBAC practice tables.
- Created reporting views for lab review queries.
- Exported an ERD and selected public-safe screenshots.
- Documented backup and recovery planning as an active learning area.

## Documentation

- [Lab Overview](docs/01-lab-overview.md)
- [Environment and Tools](docs/02-environment-and-tools.md)
- [PostgreSQL Installation and Configuration](docs/03-postgresql-installation-and-configuration.md)
- [Database Schema Design](docs/04-database-schema-design.md)
- [Backup and Recovery Evidence](docs/05-backup-and-recovery-evidence.md)
- [Evidence Collection Method](docs/06-evidence-collection-method.md)
- [Lessons Learned](docs/07-lessons-learned.md)
- [Next Steps](docs/08-next-steps.md)

LinkedIn-ready materials:

- [LinkedIn Project Description](linkedin-project-description.md)
- [LinkedIn Progress Post](linkedin-progress-post.md)

Publication support:

- [Publication Checklist](PUBLICATION_CHECKLIST.md)
- [Selected Screenshots](screenshots/)

## Public Screenshots Included

This public package includes selected screenshots that show database design work without raw command output or private environment details:

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

## Credentials and Private Evidence

Credentials, passwords, private keys, raw evidence files, local IP details, command logs, system inventory, backup archives, and private source evidence are intentionally excluded from this public version.

## Next Planned Lab Additions

- Add representative sample data.
- Practice PostgreSQL backup and restore.
- Expand reporting views and validation queries.
- Practice permissions and role management.
- Add monitoring and PostgreSQL log review.
- Practice indexing and query analysis.
- Add replication later as an advanced lab milestone.
