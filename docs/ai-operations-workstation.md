# AI Operations Workstation

The Acer Nitro V serves as the AI operations and development workstation for the PostgreSQL DBA home lab.

## Current hardware summary

- Windows 11
- Intel Core i7-13620H
- NVIDIA RTX 4050 Laptop GPU
- 64 GB DDR5 RAM

## Software stack

- Docker Desktop
- Docker Compose
- WSL 2 environment provided through Docker Desktop
- VS Code
- PowerShell
- OpenSSH
- Git and GitHub
- Ollama
- Odysseus

## Local model architecture

- Primary local model: qwen2.5-coder:14b
- Faster fallback model: qwen2.5-coder:7b
- Local model server: Ollama
- AI workspace: Odysseus
- Docker-to-Ollama endpoint: http://host.docker.internal:11434/v1

## Completed local model validation

The local model workflow has been validated. The 14B model successfully answered a PostgreSQL replication diagnostic prompt and helped reason about recovery mode and replication monitoring checks. The testing also showed that the workstation can support local AI-assisted operations without relying on external hosted model services.

## AI-assisted DBA workflows already performed

The Acer workstation has already been used for:

- SQL review and troubleshooting support
- Bash review and script validation discussion
- Documentation drafting and repository updates
- Git and GitHub workflow support
- Automation planning for the db-ops server
- Portfolio narrative development

## Relationship between Acer, GitHub, and db-ops

The Acer workstation is the editing and review environment. GitHub stores the repository history and documentation. db-ops is the server where the health-check scripts are run and validated. This separation keeps the lab workflow realistic and avoids putting operational execution fully on the AI workstation.

## Security and operational separation

Commands and scripts are reviewed and tested before operational use. The AI workstation is not treated as a trusted executor for production-style operations by default. Instead, it supports planning, reasoning, review, documentation, and repository maintenance while the lab services remain on the dedicated lab systems.

## Planned enhancements

Planned next steps for the workstation include:

- Broader use of local models for SQL and Bash review
- More structured automation review workflows
- Additional documentation and evidence capture for the portfolio
- Continued refinement of the GitHub workflow around milestones and validation notes
