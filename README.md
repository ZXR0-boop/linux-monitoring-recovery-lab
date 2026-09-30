# Linux Monitoring & Recovery Lab

A personal Linux home lab focused on **monitoring, troubleshooting, and bounded recovery**. I used Ubuntu, CasaOS, Docker, and n8n to work through host health checks, local event logging, Discord notifications, and a disk-cleanup recovery workflow. I also ran Ollama locally and later moved Plex and media storage to a UGREEN NAS.

I built this lab to learn how to operate services, diagnose failures, and turn repeatable checks into workflows. It supports my transition from physical security and operations into IT and cybersecurity.

## What the project demonstrates

| Area | Work represented here |
| --- | --- |
| Linux administration | Ubuntu/CasaOS operation, SSH commands, storage checks, and investigation of service behavior |
| Monitoring | n8n branches for host checks; Uptime Kuma availability monitoring and deliberate failure testing |
| Recovery | Disk usage check → diagnosis → journal/package-cache cleanup → usage verification |
| Logging and alerts | Local health-log entries and Discord notification branches recorded in the build discussions |
| Containers | Docker-hosted applications; investigation of container connectivity, resource limits, and storage paths |
| Local AI | Ollama model/API tests and troubleshooting of chat-interface latency |
| Networking and storage | Tailscale remote access troubleshooting, NAS SMB configuration, and Plex library/storage troubleshooting |

**Project scope:** this repository documents the portions of the lab that I was able to preserve accurately. It includes three Bash scripts derived from the disk-monitoring and recovery commands I used, but not a complete n8n deployment export. Some branch behavior is documented from project notes where the original executable artifacts were no longer available. Scheduling, an automated AI-to-recovery connection, and unrestricted service/container repair are not presented as completed features. See the [n8n monitoring and recovery notes](docs/n8n-monitoring-recovery.md) for the technical walkthrough.

## Architecture

```mermaid
flowchart TD
    Clients["User devices"] --> LAN["Router and LAN"]
    LAN --> Host["Ubuntu and CasaOS host"]
    LAN --> NAS["UGREEN NAS"]

    subgraph OriginalLab["Original Linux lab"]
        Host --> Apps["Docker applications"]
        Apps --> N8N["n8n workflows"]
        N8N --> SSH["SSH host checks"]
        SSH --> Decisions["Threshold decisions"]
        Decisions --> Cleanup["Disk cleanup and verification"]
        Decisions --> Log["Local health log"]
        Cleanup --> Log
        Log --> Alerts["Discord notifications"]
        Host --> AI["Ollama local inference"]
    end

    subgraph LaterStorage["Later storage and Plex phase"]
        NAS --> SMB["SMB file access"]
        NAS --> Plex["Plex container"]
    end