# AI Operations Workstation

The Acer Nitro V 15 is used as the AI operations workstation for the PostgreSQL DBA home lab.

## Purpose

The Acer runs Odysseus, Ollama, Docker, and local coding models to support DBA learning, SQL review, automation planning, troubleshooting, GitHub documentation, and lab health reporting.

The Acer Nitro V is not currently used as the main PostgreSQL server, replica server, or operations VM. Its role is to act as the AI-assisted control center for the lab.

## Current Local AI Model Setup

- Primary local model: `qwen2.5-coder:14b`
- Fast fallback model: `qwen2.5-coder:7b`
- Local model server: Ollama
- AI workspace: Odysseus
- Docker endpoint used by Odysseus: `http://host.docker.internal:11434/v1`

## Validation Result

The `qwen2.5-coder:14b` model successfully responded to a PostgreSQL DBA test prompt about checking replica recovery mode.

Expected SQL command:

```sql
SELECT pg_is_in_recovery();
```

The model also suggested checking replica streaming status with:

```sql
SELECT * FROM pg_stat_wal_receiver;
```

During testing, GPU usage peaked around 82%, and the response speed was acceptable. This confirms that the Acer Nitro V can function as the local AI operations workstation for the DBA lab.

## Role in the DBA Lab

Current lab role separation:

- HP Envy: Hyper-V host and main lab machine
- `db-primary`: PostgreSQL primary database server
- `db-replica`: PostgreSQL replica database server
- `db-ops`: automation, monitoring, and reporting server
- Acer Nitro V: AI operations workstation

The Acer Nitro V supports the lab without replacing the core DBA infrastructure. This keeps the lab architecture realistic because production-style DBA environments usually separate database servers, monitoring/automation servers, and administrator workstations.

## Planned Uses

The Acer Nitro V will support:

- DBA lab documentation
- SQL script review
- Bash script review
- Python automation review
- GitHub repository improvement
- Automation planning
- Health report design
- Troubleshooting support
- Prometheus documentation
- Grafana documentation
- Backup and restore workflow documentation
- Portfolio writeups
- Resume and LinkedIn project descriptions

## DBA Automation Role

The Acer Nitro V will be used to design and review automation workflows, while the scheduled automation should primarily run from the `db-ops` server.

The intended automation architecture is:

```text
Acer Nitro V
  ├── Odysseus
  ├── Ollama
  ├── Docker
  ├── VS Code
  ├── GitHub repository clone
  └── AI-assisted script/documentation review

db-ops
  ├── cron jobs
  ├── health-check scripts
  ├── backup validation scripts
  ├── replication checks
  ├── Prometheus
  ├── Grafana
  └── automated health report delivery

db-primary
  └── PostgreSQL primary database server

db-replica
  └── PostgreSQL streaming replica server
```

## Health Report Scope

The planned automated DBA lab health report should check:

- `db-primary` reachable
- `db-replica` reachable
- `db-ops` reachable
- PostgreSQL service running
- Replica is in recovery mode
- Replication status
- Replication lag
- Latest backup exists
- Backup file size looks valid
- Row counts and validation checks
- Prometheus targets are up
- Grafana service is running
- Grafana is reachable
- Grafana dashboard exists or loads
- Disk space
- RAM and CPU snapshot
- GitHub repository status

## DBA Skills Practiced

This workstation supports learning and portfolio development in the following DBA-relevant areas:

- PostgreSQL administration
- SQL diagnostics
- Replication monitoring
- Backup verification
- Restore readiness
- Linux automation
- Cron scheduling
- Bash scripting
- Python scripting
- Prometheus monitoring
- Grafana dashboards
- Git and GitHub workflow
- Technical documentation
- AI-assisted operations workflows
- Incident-style reporting

## Operating Principle

The Acer Nitro V should help plan, review, explain, and document the DBA lab. The actual database services and scheduled monitoring should remain on the lab servers, especially `db-primary`, `db-replica`, and `db-ops`.

This separation makes the lab more realistic and helps build skills that are directly relevant to database administration, systems administration, monitoring, and automation.