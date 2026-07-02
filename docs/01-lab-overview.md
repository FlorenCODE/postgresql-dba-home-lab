# Lab Overview

## Why I Built This Lab

I built this PostgreSQL DBA home lab to practice database administration concepts in a controlled local environment. The goal is to show practical learning, documentation discipline, and evidence-backed progress without presenting the lab as a production system.

## Learning Objective

The main objective is to practice the work habits of a DBA:

- Install and validate PostgreSQL in a lab environment.
- Organize database objects into schemas.
- Design relational tables with keys, constraints, and indexes.
- Understand role and permission concepts.
- Collect reviewable evidence without exposing credentials.
- Plan backup, restore, monitoring, and replication exercises.
- Document completed work separately from planned work.

## Current Architecture

The lab uses a Windows-based workstation with Hyper-V virtualization. PostgreSQL runs on an Ubuntu Server virtual machine. pgAdmin is used for database inspection, query review, ERD work, and screenshots. PowerShell and SSH are used for local administration and evidence collection.

Public-safe architecture summary:

- Windows host
- Hyper-V VM
- Ubuntu Server
- PostgreSQL
- pgAdmin
- SSH and PowerShell workflow
- Schema-only dump and metadata exports
- ERD and selected screenshots
- Backup and recovery planning tools

## Completed Work

- Created a local PostgreSQL lab environment.
- Created a PostgreSQL lab database.
- Created schemas for application, audit, security, and reporting work.
- Designed relational application tables.
- Added primary keys, foreign keys, unique constraints, check constraints, and indexes.
- Created audit and security/RBAC practice tables.
- Created reporting views for lab queries.
- Exported an ERD and selected public screenshots.
- Started backup and recovery planning documentation.
- Add realistic sample data.
- Perform formal backup and restore drills.
- Expand reporting views and validation queries.
- Practice least-privilege roles and permissions.
- Add monitoring and log review.
- Practice query plans and indexing analysis.
- Add replication later as an advanced milestone.
