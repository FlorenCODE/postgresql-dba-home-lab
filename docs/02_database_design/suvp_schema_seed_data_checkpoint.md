# SUVP Schema and Synthetic Seed Data Checkpoint

## Purpose

This checkpoint documents the SUVP-compatible database schema and synthetic seed data added to the PostgreSQL DBA lab.

The goal was to prepare the `dba_lab` database for future integration with the Student Understanding Verification Platform by creating realistic synthetic records for instructors, students, courses, enrollments, assessment sessions, student responses, understanding reports, audit events, and security role mappings.

## Environment

| Component | Value |
|---|---|
| Primary server | `db-primary` |
| Replica server | `db-replica` |
| Database | `dba_lab` |
| Execution tool | pgAdmin |
| SQL file location | `03_portfolio_workspace\sql\05_suvp_schema_seed_data` |
| Evidence location | `03_portfolio_workspace\evidence\suvp_schema_seed_data` |

## SQL Files Created

| File | Purpose |
|---|---|
| `00_current_database_inventory.sql` | Captures current schemas, tables, columns, constraints, indexes, and row counts |
| `01_constraint_definitions.sql` | Captures exact constraint definitions and allowed CHECK values |
| `02_seed_readiness_identity_rowcounts.sql` | Confirms identity/default columns and captures pre-seed row counts |
| `03_suvp_synthetic_seed_data.sql` | Inserts synthetic SUVP-compatible data into existing tables |
| `04_suvp_seed_validation_queries.sql` | Validates seeded data and confirms replication to db-replica |

## Synthetic Data Inserted

The seed script inserted realistic lab data for:

- instructors
- students
- courses
- course enrollments
- assessment sessions
- student responses
- understanding reports
- audit events
- security roles
- security permissions
- role permissions
- user role assignments

## Post-Seed Row Counts on db-primary

| Table | Row Count |
|---|---:|
| app.assessment_sessions | 10 |
| app.course_enrollments | 13 |
| app.courses | 4 |
| app.instructors | 4 |
| app.student_responses | 7 |
| app.students | 10 |
| app.understanding_reports | 7 |
| audit.audit_events | 13 |
| security.app_permissions | 12 |
| security.app_roles | 4 |
| security.role_permissions | 27 |
| security.user_role_assignments | 11 |

## Replication Validation on db-replica

The seeded data was validated on `db-replica` using row-count checks. The replicated row counts matched the data inserted on `db-primary`.

| Table | Row Count on db-replica |
|---|---:|
| app.assessment_sessions | 10 |
| app.course_enrollments | 13 |
| app.courses | 4 |
| app.instructors | 4 |
| app.student_responses | 7 |
| app.students | 10 |
| app.understanding_reports | 7 |
| audit.audit_events | 13 |
| security.app_permissions | 12 |
| security.app_roles | 4 |
| security.role_permissions | 27 |
| security.user_role_assignments | 11 |

## Validation Evidence

Screenshots and CSV exports were saved for:

```text
2026-06-29_09_db-primary_seed_readiness_identity_columns
2026-06-29_10_db-primary_seed_readiness_pre_seed_row_counts
2026-06-29_11_db-primary_suvp_seed_script_post_seed_counts
2026-06-29_12_db-primary_suvp_seed_validation_core_entities
2026-06-29_13_db-primary_suvp_seed_validation_assessment_sessions_joined
2026-06-29_14_db-primary_suvp_seed_validation_responses_reports_joined
2026-06-29_15_db-primary_suvp_seed_validation_audit_events
2026-06-29_16_db-replica_suvp_seed_data_replicated_row_counts