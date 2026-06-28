# Evidence Collection Method

## Collection Approach

The full lab uses private source evidence to support the portfolio, but only selected public-safe materials are included here.

Evidence collection methods used in the lab:

- Windows PowerShell workflow.
- SSH into the Ubuntu PostgreSQL VM.
- PostgreSQL metadata queries.
- Schema-only dump.
- pgAdmin screenshots.
- CSV exports from query results.
- ERD export and screenshots.

## Why Screenshots and Exports Matter

Screenshots show that the database objects were visible in tools like pgAdmin. CSV exports and SQL metadata provide structured evidence that can be searched, reviewed, and compared over time.

Using both is stronger than screenshots alone because it supports both visual review and technical inspection.

## Public Evidence Included

This public version includes only selected screenshots related to database design:

- [Lab schemas](../screenshots/04_lab_schemas.png)
- [Application tables](../screenshots/05_app_schema_tables.png)
- [Application column summary](../screenshots/06b_app_table_column_summary.png)
- [Constraints and keys](../screenshots/07_constraints_primary_foreign_keys.png)
- [Foreign key relationships](../screenshots/08_foreign_key_relationships.png)
- [Indexes](../screenshots/09_indexes.png)
- [Audit schema table](../screenshots/10_audit_schema_tables.png)
- [Security schema tables](../screenshots/12_security_schema_tables.png)
- [Reporting views](../screenshots/13_reporting_schema_views.png)
- [Database object summary](../screenshots/15_database_object_summary.png)
- [ERD screenshot](../screenshots/17_erd_schema_diagram_app_schema_screenshot.png)
- [ERD zoomed-out screenshot](../screenshots/17_erd_schema_diagram_app_schema_screenshot-zoomed-out.png)

## What Is Not Public

The private evidence folder is not part of this publishable package. It contains raw source material used for local verification and should remain private.

Excluded from this public version:

- Raw command output.
- Local IP addresses.
- Hostnames and private system identifiers.
- Full system inventory.
- Full role exports.
- Credential-related files.
- Backup archives and backup path details.
- Schema dump files and raw CSV exports.

## Credential Handling

Credentials, passwords, private keys, tokens, and credential-bearing connection strings are intentionally excluded.
