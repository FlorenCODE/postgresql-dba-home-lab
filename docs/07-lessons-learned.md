# Lessons Learned

This lab has helped me understand that DBA work is not only about creating tables. It also involves environment discipline, evidence collection, recoverability, security awareness, and clear documentation.

I learned how useful PostgreSQL schemas are for organizing database responsibilities. Separating `app`, `audit`, `security`, and `reporting` objects made the design easier to explain and review.

I practiced designing relational tables with primary keys, foreign keys, unique constraints, check constraints, and indexes. Seeing the design through metadata, screenshots, and an ERD helped reinforce how database structure can be validated from multiple sources.

I learned that foreign keys and constraints communicate important rules about the data model. They help protect data quality and make the design easier to understand.

The ERD was especially helpful because it provided a visual way to confirm table relationships. It also makes the portfolio easier for reviewers to understand without reading raw SQL.

I practiced working across Windows and Linux workflows by using PowerShell and SSH. That helped me connect desktop administration, virtualization, Linux service checks, and PostgreSQL review into one learning process.

Hyper-V gave me a safe place to build the lab without touching a production system. It also helped me understand why VM setup, networking, and connectivity are part of a database environment.

Backup planning is an area I am still building. I have started gathering planning evidence, but a real DBA portfolio needs restore validation, not just backup references.

I also learned the value of documentation discipline. The project is stronger when it clearly separates completed work, observed evidence, and planned next steps.
