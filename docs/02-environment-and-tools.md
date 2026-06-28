# Environment and Tools

## Lab Environment

This public portfolio describes the environment at a high level. Private host identifiers, local IP addresses, raw command output, and system inventory details are intentionally excluded.

The lab environment includes:

- A Windows host system.
- Hyper-V for virtualization.
- An Ubuntu Server virtual machine for PostgreSQL.
- PostgreSQL as the database engine.
- pgAdmin 4 for visual database administration and ERD work.
- SSH for Linux administration.
- PowerShell for Windows-side collection and workflow support.

## PostgreSQL and pgAdmin

PostgreSQL is the core database platform used in this lab. pgAdmin was used to connect to the lab database, inspect schemas, run metadata queries, export results, and create ERD evidence.

Public screenshots:

- [Lab schemas](../screenshots/04_lab_schemas.png)
- [Application tables](../screenshots/05_app_schema_tables.png)
- [Database object summary](../screenshots/15_database_object_summary.png)

## PowerShell and SSH Workflow

The lab uses both Windows and Linux administration workflows. PowerShell supports the host-side workflow, while SSH supports the Ubuntu/PostgreSQL server workflow.

This matters for DBA learning because database administration often requires moving between database tools, operating system tools, network checks, service checks, and documentation.

## Backup and Recovery Planning Tools

Backup and recovery are included as a learning area. The current public portfolio does not claim a production-grade backup solution. It documents that backup tooling and recovery planning are being explored, and that PostgreSQL-native backup and restore drills are planned.

## Public-Safety Notes

This public version excludes:

- Raw system inventory.
- Local network details.
- Command output logs.
- Full backup or recovery-tool evidence.
- Credential-adjacent files.
- Private source evidence.
