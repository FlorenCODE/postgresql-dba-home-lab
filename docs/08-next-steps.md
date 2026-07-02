# Next Steps

This PostgreSQL DBA lab has progressed from a single-server schema project into a multi-server DBA practice environment. The lab now includes a primary PostgreSQL server, a streaming replica, an operations server, synthetic seed data, reporting views, pgAdmin access, backup/restore practice, operations checks, and basic monitoring components.

This file tracks the current status of the lab and the remaining work needed to make it stronger, more repeatable, and portfolio-ready.

## Current Lab Architecture

The current lab environment includes:

- Windows host laptop running pgAdmin.
- `db-primary` running PostgreSQL and hosting the `dba_lab` database.
- `db-replica` configured as a PostgreSQL streaming replica.
- `db-ops` configured as an operations/admin server.
- Prometheus running on `db-ops`.
- Node Exporter running on `db-ops`.
- PostgreSQL command-line client tools available on `db-ops`.

The lab is designed to support hands-on DBA practice with PostgreSQL administration, Linux server usage, replication, backups, restores, monitoring, role design, query analysis, and technical documentation.

## Completed Milestones

The lab currently includes the following completed work:

- `db-primary` is running PostgreSQL 18.4 and hosting the `dba_lab` database.
- Core schemas have been created, including `app`, `audit`, `security`, `reporting`, and `lab_admin`.
- Application-style tables have been created for the Student Understanding Verification Platform database model.
- Audit-related database objects have been created.
- Security/RBAC-related database objects have been created.
- Reporting views have been created and tested against synthetic data.
- Synthetic portfolio-safe data has been loaded into the lab.
- pgAdmin has been used from the Windows host to inspect and manage the PostgreSQL environment.
- `db-replica` has been configured as a PostgreSQL streaming replica.
- Streaming replication from `db-primary` to `db-replica` has been verified.
- Read-only replica behavior has been confirmed.
- A replication heartbeat table has been used to test replication behavior.
- `db-ops` has been configured as an operations/admin server.
- `psql` is installed on `db-ops`.
- `db-ops` has successfully connected to `db-primary` using `psql`.
- Prometheus is running on `db-ops`.
- Node Exporter is running on `db-ops`.
- Prometheus target health has been confirmed for the `prometheus` and `node` jobs.
- Backup and restore practice has been performed using PostgreSQL-native tools.
- Restore validation has been performed against a separate restore-test database.
- Row count and restored object validation have been started as part of restore testing.
- Replication health checks have been performed manually.
- PostgreSQL service health checks have been performed manually.
- GitHub documentation, screenshots, and SQL scripts have been started for portfolio use.

## Maintain and Expand Synthetic Data

Synthetic seed data has already been added. The next step is to maintain and expand it only where useful for additional DBA exercises.

Remaining focus areas:

- Add more synthetic rows for larger query-analysis practice.
- Add edge-case records for validation testing.
- Add enough data to make reporting views more realistic.
- Keep all data synthetic and portfolio-safe.
- Avoid using real student, instructor, university, or production data.

Synthetic data should support DBA learning without creating privacy or security concerns.

## Strengthen Backup and Restore Practice

Backup and restore work has already been performed. The next step is to make the workflow more repeatable, documented, and script-friendly from `db-ops`.

Completed backup and restore work:

- Created PostgreSQL-native backups.
- Restored a backup into a separate restore-test database.
- Validated restored database objects.
- Started row count and object validation after restore.
- Practiced backup and restore as part of the DBA lab workflow.

Remaining focus areas:

- Convert the manual backup process into a reusable backup script.
- Convert restore testing into a reusable restore-validation process.
- Add a clear row-count comparison checklist.
- Validate schemas, tables, constraints, indexes, views, and selected row counts after each restore.
- Document expected restore results.
- Document common restore errors and how they were resolved.
- Keep backup files and restore-test databases organized.

The goal is to demonstrate that the database can be backed up, restored, and validated in a controlled learning environment.

## Improve Reporting Views

Reporting views have already been created and tested with synthetic data. The next step is to refine them and document their DBA value.

Completed reporting work:

- Created reporting schema objects.
- Created reporting views.
- Validated reporting views against synthetic data.

Remaining focus areas:

- Refine session overview reporting.
- Refine course assessment summaries.
- Refine student assessment history reporting.
- Refine instructor review summaries.
- Refine audit event summaries.
- Refine role and permission review queries.
- Add replication verification reporting where useful.
- Document the purpose of each reporting view.

Each reporting view should clearly explain what question it answers and how it supports administration, auditing, or application reporting.

## Continue Permissions and Role Practice

Security and role-related objects already exist, but least-privilege access testing should continue.

Completed security work:

- Created security/RBAC-related database objects.
- Started organizing the lab around separate administrative, application, reporting, and security concepts.

Remaining focus areas:

- Separate admin, read-only, application, reporting, and maintenance roles.
- Grant schema permissions intentionally.
- Grant table and view permissions intentionally.
- Test access from different roles.
- Confirm which actions are allowed and denied.
- Document permission behavior without exposing passwords or secrets.
- Keep credentials out of GitHub.

This section should demonstrate DBA understanding of access control, role design, and operational safety.

## Expand Monitoring and Log Review

Basic monitoring is now running on `db-ops` with Prometheus and Node Exporter.

Completed monitoring work:

- Prometheus is running on `db-ops`.
- Node Exporter is running on `db-ops`.
- Prometheus target health was confirmed through the Prometheus API.
- The `node` target is up.
- The `prometheus` target is up.

Remaining focus areas:

- Add monitoring targets for `db-primary`.
- Add monitoring targets for `db-replica`.
- Review PostgreSQL service health from a monitoring perspective.
- Review database connection activity.
- Review PostgreSQL logs.
- Track errors and failed connection attempts.
- Explore PostgreSQL-specific exporters after the core lab is stable.
- Document what each monitoring target measures.

The goal is to make monitoring useful for DBA learning, not just to install tools.

## Practice Indexing and Query Analysis

Use the existing synthetic data, and later expanded sample data, to practice query plans and indexing decisions.

Remaining focus areas:

- Run `EXPLAIN`.
- Run `EXPLAIN ANALYZE`.
- Compare query behavior before and after indexing changes.
- Identify slow or inefficient queries.
- Add indexes intentionally.
- Document why each index was added or changed.
- Avoid adding indexes without a clear reason.
- Compare query performance before and after index changes.

This section should show practical DBA judgment, not just SQL syntax.

## Continue Replication Practice

Streaming replication has already been configured and verified. The next step is to continue using it for deeper DBA learning.

Completed replication work:

- Created a separate PostgreSQL replica server.
- Configured primary-to-replica streaming replication.
- Verified that writes on `db-primary` appear on `db-replica`.
- Confirmed read-only replica behavior.
- Verified replication through SQL checks and pgAdmin.
- Used a replication heartbeat table for testing.

Remaining focus areas:

- Document the replication setup clearly.
- Capture screenshots of replication status.
- Query `pg_stat_replication` on `db-primary`.
- Query `pg_is_in_recovery()` on `db-replica`.
- Practice controlled replica restart behavior.
- Observe what happens when the primary or replica is unavailable.
- Study failover concepts in a learning context.
- Avoid presenting the lab as production-ready high availability.

## DBA Operations Checks and Scripts

Several core DBA operations checks have already been performed manually from the lab environment. The next step is to convert these checks into repeatable, documented scripts that can be run from `db-ops`.

Completed checks and workflows:

- Confirmed database connectivity from `db-ops` to `db-primary` using `psql`.
- Confirmed `db-ops` has the PostgreSQL client installed.
- Confirmed backup and restore workflow using PostgreSQL-native tools.
- Restored a backup into a separate restore-test database.
- Validated restored database objects across the application, audit, security, reporting, and lab administration schemas.
- Started row-count validation as part of restore testing.
- Confirmed replication health through primary-to-replica testing.
- Confirmed read-only replica behavior.
- Confirmed PostgreSQL service health during server validation.
- Confirmed Prometheus and Node Exporter target health on `db-ops`.

Remaining script-focused work:

- Convert the database connectivity check into a reusable script.
- Convert the backup command into a reusable backup script.
- Convert the restore validation process into a reusable restore-test script.
- Add a row-count validation script for comparing source and restored databases.
- Convert replication health checks into a reusable script.
- Convert PostgreSQL service health checks into a reusable script.
- Add clear script output so success and failure are easy to understand.
- Document where each script runs, what it checks, and what result is expected.

The goal is no longer to prove these tasks can be done once. The next goal is to make them repeatable, organized, and portfolio-ready.

## Improve Documentation

Update the repository documentation as the lab progresses.

Remaining documentation updates:

- Current architecture diagram.
- Server inventory.
- PostgreSQL version information.
- Network/IP reference.
- Schema overview.
- Synthetic data summary.
- Reporting view summary.
- Replication setup notes.
- Monitoring setup notes.
- Backup and restore procedure.
- Restore validation procedure.
- Role and permission testing notes.
- Operations script documentation.
- Lessons learned.
- Screenshots showing important milestones.

Sensitive values such as passwords, connection strings, API keys, tokens, private configuration values, and unnecessary secret details should not be committed to GitHub.

## Portfolio Readiness

After the core DBA exercises are complete, organize the repository so it can be used as a professional portfolio project.

Remaining portfolio improvements:

- Clear project overview.
- Architecture summary.
- DBA skills demonstrated.
- Screenshots with explanations.
- Sanitized SQL scripts.
- Sanitized configuration examples.
- Synthetic data explanation.
- Backup and restore walkthrough.
- Restore validation walkthrough.
- Replication walkthrough.
- Monitoring walkthrough.
- Security and permissions walkthrough.
- Query analysis walkthrough.
- Lessons learned section.
- Clear explanation that the lab is for learning and is not a production deployment.

The final repository should show practical DBA ability in PostgreSQL administration, Linux server usage, remote database access, monitoring, backup and restore, replication, security, query analysis, operations scripting, and technical documentation.

## Important Reminder

This lab is a learning and portfolio environment. It should not be described as a production deployment or production-ready high availability system.

All documentation should remain clear, accurate, and sanitized before being committed to GitHub.
