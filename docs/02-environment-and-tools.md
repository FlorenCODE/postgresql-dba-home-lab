# Environment and Tools

## Overview

This document summarizes the current environment and software stack used for the PostgreSQL DBA home lab. It is written for a public portfolio audience and avoids private addresses, credentials, and raw operational logs.

## HP Envy

### Role

The HP Envy serves as the main Windows-based lab host for virtualization and Windows administration.

### Operating system

- Windows 11 Pro
- Hyper-V host

### Important software

- Hyper-V Manager
- PowerShell
- pgAdmin 4
- SSH client tools
- Git and GitHub client workflow

### Skills practiced

- Windows and Hyper-V administration
- Linux VM lifecycle management
- PostgreSQL administration from a Windows workstation
- Troubleshooting and evidence collection

### Relationship to the rest of the architecture

The HP Envy provides the virtualization foundation for the lab and is the primary Windows-side environment used to manage the Ubuntu servers and collect evidence.

## Acer Nitro V

### Role

The Acer Nitro V is the AI operations and development workstation for the lab.

### Operating system

- Windows 11

### Important software

- Docker Desktop
- Docker Compose
- WSL 2 environment provided through Docker Desktop
- VS Code
- PowerShell
- OpenSSH
- Git and GitHub
- Ollama
- Odysseus

### Skills practiced

- AI-assisted SQL and Bash review
- Documentation and portfolio writing
- Troubleshooting support
- Git-based collaboration and repository maintenance
- Local LLM experimentation and validation

### Relationship to the rest of the architecture

The Acer is not the database engine. It is used to review scripts, write documentation, coordinate repository updates, and assist with operational reasoning while the actual database services remain on the lab servers.

## db-primary

### Role

db-primary is the PostgreSQL primary server for the lab.

### Operating system

- Ubuntu Server

### Important software

- PostgreSQL 18.x
- PostgreSQL client tools
- SSH access for administration
- Standard system monitoring tools

### Skills practiced

- PostgreSQL server administration
- Database connectivity validation
- Primary-side replication checks
- Troubleshooting and evidence collection

### Relationship to the rest of the architecture

db-primary is the writable source server for replication and the main PostgreSQL workload in the lab.

## db-replica

### Role

db-replica is the PostgreSQL streaming replica used for standby validation and replication troubleshooting.

### Operating system

- Ubuntu Server

### Important software

- PostgreSQL
- PostgreSQL replication configuration
- SSH access for administration
- Standard system monitoring tools

### Skills practiced

- Standby server administration
- WAL receiver validation
- Replication troubleshooting
- Replay delay analysis

### Relationship to the rest of the architecture

db-replica receives WAL data from db-primary and is used to verify replication behavior in the lab.

## db-ops

### Role

db-ops is the operations and automation server for the lab.

### Operating system

- Ubuntu Server

### Important software

- Bash
- PostgreSQL client tools
- Health-check scripts
- Logging and validation workflow
- Planned future monitoring and reporting tools

### Skills practiced

- Bash scripting
- Operational validation and health checks
- Linux administration
- Automation workflow planning
- Documentation of test runs

### Relationship to the rest of the architecture

db-ops is the current execution point for the completed health checks and the intended future home for scheduled automation, reports, and monitoring integration.

## Shared Git and GitHub workflow

### Role

Git and GitHub provide version control and portfolio organization for the repository.

### Important workflow elements

- The Acer Nitro V is used for editing, documentation, and review
- db-ops pulls the latest repository state and runs validated scripts
- The repository stores documentation, scripts, troubleshooting notes, and milestone writeups

### Skills practiced

- Git branching and change tracking
- Pull request-style documentation workflow
- Repository maintenance for portfolio use
- Collaboration between workstation and lab systems

## Public-safety notes

This public version excludes private addresses, credentials, raw logs, and sensitive operational details while still documenting the architecture and the learning outcomes.
