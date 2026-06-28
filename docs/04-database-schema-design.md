# Database Schema Design

## Design Summary

The lab database is organized into four schemas:

- `app`: core application-style tables for a student-understanding assessment model.
- `audit`: audit event tracking.
- `security`: role and permission modeling for RBAC practice.
- `reporting`: reporting views for review queries.

Public screenshots:

- [Lab schemas](../screenshots/04_lab_schemas.png)
- [Database object summary](../screenshots/15_database_object_summary.png)

## App Schema

The `app` schema contains the main relational tables for the lab scenario:

- `students`: student identity and status fields.
- `instructors`: instructor identity, department, email, and status fields.
- `courses`: course code, title, term, academic year, instructor, and active status.
- `course_enrollments`: student-to-course enrollment relationships.
- `assessment_sessions`: assigned assessment sessions connected to students, instructors, and courses.
- `student_responses`: written or oral response records connected to assessment sessions.
- `understanding_reports`: assessment outcome records, including scores, levels, strengths, gaps, and follow-up notes.

Public screenshots:

- [Application tables](../screenshots/05_app_schema_tables.png)
- [Application column summary](../screenshots/06b_app_table_column_summary.png)

## Audit Schema

The `audit` schema includes an audit event table used to practice tracking actions, actors, event summaries, structured event details, and timestamps.

Public screenshot:

- [Audit schema table](../screenshots/10_audit_schema_tables.png)

## Security Schema

The `security` schema is used for RBAC-style practice. It includes tables for application roles, permissions, role-permission mappings, and user role assignments.

Public screenshot:

- [Security schema tables](../screenshots/12_security_schema_tables.png)

## Reporting Schema

The `reporting` schema contains reporting views for reviewing course assessment, session, audit, role/permission, and student assessment information.

Public screenshot:

- [Reporting views](../screenshots/13_reporting_schema_views.png)

Reporting is started and remains a planned area for expansion after sample data and query validation are added.

## Keys, Constraints, and Relationships

The lab practices relational design with:

- Primary keys for stable table identity.
- Foreign keys for table relationships.
- Unique constraints for business rules.
- Check constraints for controlled values and required logic.
- Indexes for lookup and query-support practice.

Public screenshots:

- [Constraints and keys](../screenshots/07_constraints_primary_foreign_keys.png)
- [Foreign key relationships](../screenshots/08_foreign_key_relationships.png)
- [Indexes](../screenshots/09_indexes.png)

## ERD Evidence

The ERD visually confirms the relational structure of the main application schema. It helps reviewers understand the design without reading raw SQL.

Public screenshots:

- [ERD screenshot](../screenshots/17_erd_schema_diagram_app_schema_screenshot.png)
- [ERD zoomed-out screenshot](../screenshots/17_erd_schema_diagram_app_schema_screenshot-zoomed-out.png)
