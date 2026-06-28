# Next Steps

This PostgreSQL DBA lab is intentionally in progress. The next steps are focused on turning the current schema design into a stronger database administration practice environment.

## Add Sample Data

Add representative sample data for students, instructors, courses, enrollments, assessment sessions, responses, understanding reports, audit events, roles, and permissions.

## Practice Backup and Restore

Run PostgreSQL-native backup and restore exercises after sample data is added.

Planned exercises:

- Create logical backups.
- Restore into a separate test database.
- Validate row counts, schema objects, constraints, and indexes after restore.
- Document recovery steps and lessons learned.

## Expand Reporting Views

The reporting schema exists, but it should be expanded and validated against sample data.

Planned focus areas:

- Session overview reporting.
- Course assessment summaries.
- Student assessment history.
- Audit event summaries.
- Role and permission review.

## Practice Permissions and Roles

Practice least-privilege role design in the lab.

Planned focus areas:

- Separate admin, read-only, application, and reporting roles.
- Grant schema, table, and view permissions intentionally.
- Test access from different roles.
- Document behavior without exposing credentials.

## Add Monitoring and Log Review

Add PostgreSQL log review and basic monitoring practice.

Planned focus areas:

- Review database logs.
- Track service health.
- Review connection and error events.
- Explore monitoring tools after the core lab is stable.

## Practice Indexing and Query Analysis

Use sample data to practice query plans and indexing decisions.

Planned focus areas:

- Run query plan reviews.
- Compare query behavior before and after indexing changes.
- Document why indexes are added or changed.

## Add Replication Later

After the single-server lab is documented and tested, expand the environment with replication.

Planned focus areas:

- Add a second PostgreSQL VM.
- Practice streaming replication concepts.
- Document primary/replica roles.
- Test read-only replica behavior and failover concepts in a learning context.
