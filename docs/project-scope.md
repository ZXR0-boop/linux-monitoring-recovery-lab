# Project Scope

This project grew over several phases, so I separate features by how directly I can still support them with preserved commands, test results, or project notes.

## Implemented

These parts of the lab were used as working components:

- Ubuntu/CasaOS home-server environment
- Docker-hosted applications
- HTTP/application availability monitoring
- local Ollama inference and API testing
- NAS-hosted Plex
- SMB access to NAS storage

## Configured and tested

These features were configured and exercised during the lab, although the complete original deployment artifacts were not preserved:

- n8n SSH-based host checks
- disk-usage threshold branch
- disk diagnosis, cleanup, and post-cleanup verification
- CPU/temperature monitoring
- RAM/swap monitoring
- battery/AC monitoring
- network-health checks
- system-log monitoring
- local health-log writes
- Discord alerting
- Tailscale remote-access troubleshooting
- Immich/Nextcloud setup and health checks
- Plex library/rescan troubleshooting

## Planned or incomplete

I do not present these as completed features:

- recurring production scheduling for the monitoring workflow
- unrestricted service/container auto-restart
- automated AI-to-recovery execution
- SMART/disk-health monitoring
- completed failed-SSH-login monitoring
- retry/cooldown/escalation policy
- independent monitoring for full-host outages
- tested backup/redundancy design

## Why this distinction matters

The goal of this repository is to show the work accurately, including what was tested, what was only explored, and what still needs to be built. I would rather document a limitation than recreate missing implementation details and present them as original work.
