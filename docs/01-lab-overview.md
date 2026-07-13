# Lab Overview

## Why I Built This Lab

I built this PostgreSQL DBA home lab to practice database administration, Linux administration, automation, troubleshooting, and technical documentation in a controlled local environment. The goal is to show evidence-backed progress without presenting the lab as a production system.

## Learning Objective

The main objective is to practice the work habits of a DBA:

- Install and validate PostgreSQL in a hands-on lab environment
- Organize database objects into schemas and practice relational design
- Understand role and permission concepts
- Validate connectivity, health checks, and replication status
- Collect reviewable evidence without exposing credentials
- Document completed work separately from planned work

## Current architecture

The current lab uses a split architecture across two laptops and several lab systems:

- HP Envy (Windows 11 Pro, Hyper-V host): hosts the Ubuntu-based lab virtual machines
- db-primary: Ubuntu Server VM running PostgreSQL as the writable primary server
- db-ops: Ubuntu Server VM used for automation, validation, and operational testing
- db-replica: bare-metal Ubuntu Server machine running PostgreSQL as a streaming replica
- Acer Nitro V: Windows 11 workstation with Docker Desktop, VS Code, PowerShell, GitHub, Ollama, and Odysseus for AI-assisted review and documentation

This setup reflects a realistic production-style separation between database services, operations automation, and administrator workstations.

## Completed milestones

- Built a multi-system PostgreSQL DBA lab rather than a single-machine setup
- Created and validated a PostgreSQL primary server and a replica server
- Completed streaming replication and documented a real replication troubleshooting exercise
- Implemented health-check scripts for host reachability, PostgreSQL connectivity, replication verification, and system resources
- Used the Acer workstation for AI-assisted review, Bash and SQL troubleshooting, documentation, and GitHub workflow

## Current operating model

The lab currently operates with a clear division of responsibility:

- HP Envy handles virtualization and host-level administration
- db-primary serves as the PostgreSQL primary server
- db-ops runs and validates the health-check scripts
- db-replica validates standby behavior and streaming replication
- Acer Nitro V supports review, documentation, and AI-assisted operations planning

## Replication status

Streaming replication is now a completed milestone in this repository. The lab includes a documented incident and a validation workflow that confirmed replication, WAL receiver activity, and heartbeat propagation from the primary to the replica.

## Next milestones

- Add scheduled automation and report generation on db-ops
- Expand backup validation and restore documentation
- Add monitoring and dashboard work for Prometheus and Grafana
- Continue refining the portfolio narrative and supporting evidence
