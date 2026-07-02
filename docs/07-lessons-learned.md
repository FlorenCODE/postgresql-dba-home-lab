# Lessons Learned

This lab has helped me understand that DBA work is much broader than creating tables. It also involves environment discipline, schema organization, security awareness, recoverability, replication, monitoring, evidence collection, and clear technical documentation.

I learned how useful PostgreSQL schemas are for organizing database responsibilities. Separating `app`, `audit`, `security`, `reporting`, and `lab_admin` objects made the database easier to explain, validate, and maintain.

I practiced designing relational database structures with primary keys, foreign keys, unique constraints, check constraints, indexes, and schema-level organization. Seeing the design through SQL scripts, metadata queries, screenshots, pgAdmin, and an ERD helped reinforce that database structure should be verifiable from multiple sources.

I learned that foreign keys and constraints are not just technical details. They communicate important rules about the data model, protect data quality, and make the database easier for another person to understand.

The ERD was especially helpful because it provided a visual way to confirm table relationships. It also made the portfolio easier to review without requiring someone to read every SQL script first.

I learned the importance of synthetic data for database administration practice. Loading portfolio-safe sample data made it possible to test reporting views, backup and restore workflows, row counts, query behavior, and validation checks without exposing real student, instructor, university, or production data.

I practiced creating and validating reporting views. This helped me understand that reporting is not just about writing SELECT statements. Reporting views should answer useful business or administrative questions and should be tested against realistic data.

I learned that backup work is incomplete unless restore validation is also performed. Creating a backup is only one part of recoverability. Restoring into a separate test database and validating restored schemas, tables, views, constraints, indexes, and row counts is what proves the backup can actually be used.

I practiced working across Windows and Linux workflows by using PowerShell, SSH, pgAdmin, and Linux terminal commands. This helped me connect desktop administration, virtualization, Linux service checks, PostgreSQL review, and remote database access into one learning process.

Hyper-V gave me a safe place to build a realistic lab without touching a production system. It also helped me understand why VM setup, networking, IP addresses, service status, and connectivity are part of a database environment.

I learned that a DBA environment can involve multiple servers with different responsibilities. In this lab, `db-primary` acts as the main PostgreSQL server, `db-replica` acts as the streaming replica, and `db-ops` acts as the operations/admin server.

Configuring streaming replication helped me understand the difference between a primary database server and a replica. I verified that changes made on `db-primary` appeared on `db-replica`, and I confirmed that the replica behaves as a read-only server.

The replication heartbeat test helped me understand why DBAs need simple, repeatable ways to confirm that replication is working. It is not enough to assume that replication is healthy just because the servers are running.

Using `db-ops` helped me understand the value of separating operational tasks from the database server itself. Running `psql` from `db-ops` to connect to `db-primary` showed how an operations server can support backups, validation checks, monitoring checks, and future scripts.

I learned that manual DBA checks are useful, but repeatable scripts are better. Database connectivity checks, backup commands, restore validation, row count checks, replication checks, and service health checks should eventually become documented scripts that can be run consistently.

Adding Prometheus and Node Exporter introduced me to the monitoring side of DBA work. I learned that service health and target health are part of operational visibility, and that monitoring should eventually include the database servers, not only the operations server.

I learned that security and role design require intentional testing. Creating security-related objects is only the beginning. A stronger DBA lab should test which roles can read, write, report, administer, or maintain database objects.

I also learned the importance of documentation discipline. A strong portfolio should clearly separate completed work, observed evidence, remaining next steps, and lessons learned.

This project has shown me that DBA work requires both technical execution and professional judgment. The lab is not a production deployment, but it demonstrates practical learning in PostgreSQL administration, Linux server usage, pgAdmin, backup and restore, replication, monitoring, security, query validation, and documentation.
