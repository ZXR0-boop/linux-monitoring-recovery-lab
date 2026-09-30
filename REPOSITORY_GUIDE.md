# Repository handoff

## 1. Name and scope

**linux-monitoring-recovery-lab** — a public portfolio of the supported Linux, monitoring, recovery, local AI, networking, and NAS work. Files are prepared for review; nothing has been published to GitHub.

This is an evidence-based reconstruction, not a complete backup of the lab. Only three script bodies could be faithfully derived from recovered commands. Missing originals and workflow exports are identified explicitly.

## 2. Directory tree

- `linux-monitoring-recovery-lab/`
  - `.env.example`
  - `.gitignore`
  - `LICENSE`
  - `README.md`
  - `REPOSITORY_GUIDE.md`
  - `SECURITY.md`
  - `PROJECT_ACCURACY_REVIEW.md`
  - `PUBLIC_REPOSITORY_SECURITY_REVIEW.md`
  - `docs/`
    - `architecture.md`
    - `setup.md`
    - `monitoring.md`
    - `self-healing.md`
    - `local-ai.md`
    - `logging-alerts.md`
    - `networking.md`
    - `troubleshooting.md`
    - `lessons-learned.md`
    - `portfolio.md`
    - `source-provenance.md`
    - `validation.md`
    - `publishing.md`
  - `scripts/`
    - `README.md`
    - `health-check/disk_usage.sh`
    - `monitoring/disk_diagnose.sh`
    - `maintenance/disk_cleanup.sh`
  - `config-examples/`
    - `README.md`
    - `monitoring/n8n-disk-branch.md`
    - `docker/storage-layout.md`
    - `services/librechat-settings.md`
    - `systemd/README.md`
  - `diagrams/`
    - `architecture.mmd`
    - `recovery.mmd`
  - `screenshots/`
    - `README.md`
  - `tests/`
    - `test_disk_scripts.py`

## 3. Major files

| File or folder | Purpose |
| --- | --- |
| [README.md](README.md) | Recruiter entry point, architecture, supported features, skills and future work |
| [SECURITY.md](SECURITY.md) | Public-data handling and recovery precautions |
| [Accuracy review](PROJECT_ACCURACY_REVIEW.md) | Feature-by-feature implementation status and evidence limits |
| [Security review](PUBLIC_REPOSITORY_SECURITY_REVIEW.md) | Categories checked, sanitization choices, and per-file release assessment |
| [Script inventory](scripts/README.md) | Original command logic versus new wrapper changes, dependencies and usage |
| [Configuration references](config-examples/README.md) | Supported n8n, storage, AI-interface and scheduling details without fake exports |
| [Troubleshooting](docs/troubleshooting.md) | Five grounded case studies and separately labeled unresolved investigations |
| [Local AI](docs/local-ai.md) | Model hosting/testing and the limits of the recovered monitoring-integration evidence |
| [Portfolio wording](docs/portfolio.md) | Resume bullets, interview explanation, repository description and topics |
| [Screenshot plan](screenshots/README.md) | Exact capture/redaction checklist |
| [Validation](docs/validation.md) | Test outcomes and limits |
| [Publishing](docs/publishing.md) | Review/upload guidance, license and author-identity checks |
| `.env.example`, `.gitignore`, `LICENSE` | Minimal configuration template, private-file exclusions and MIT license |

## 4. IMPLEMENTED

The available record supports the Ubuntu/CasaOS host, Docker applications, HTTP availability monitoring, local Ollama inference, NAS-hosted Plex, and NAS SMB access. These are historical implementation claims, not assertions that all original services still run today.

## 5. CONFIGURED/TESTED

n8n SSH host checks; disk threshold/diagnosis/cleanup/verification; CPU, RAM/swap, battery, network and log branches to the extent described; local logging and Discord alert tests; local AI API/UI troubleshooting; overlay remote access; Immich/Nextcloud setup and collector tests; Plex rescan troubleshooting; and the GPU setting change. Several branch outcomes survive only in build recaps, as labeled in the accuracy review.

## 6. DOCUMENTED/PLANNED or not sufficiently verified

An active recurring schedule, complete AI monitoring integration, arbitrary service/container recovery, retry/cooldown/escalation guarantees, SMART and failed-SSH completion, independent host-outage monitoring, reboot-persistent battery thresholds, NFS, redundancy/backups, RAG/vector stores, and SIEM deployment. None is presented as a demonstrated completed feature.

## 7. Sensitive information removed or withheld

Actual LAN/overlay addresses, private host and service targets, original mapped ports, account names, personal paths, private identifiers, raw output and logs. No real credentials, webhook values, tokens, keys, screenshots, hardware serials, or raw deployment exports were included. The review does not claim to have found or rotated a secret when none was recovered.


## 8. GitHub description

Personal Ubuntu/CasaOS lab documenting n8n monitoring, bounded disk recovery, local Ollama testing, Docker troubleshooting, and NAS/SMB integration.

## 9. Topics

`homelab` `linux` `ubuntu` `docker` `casaos` `n8n` `monitoring` `automation` `troubleshooting` `ollama` `nas` `smb` `portfolio`



## 10. Public-release assessment

The supplied files have been reviewed for public disclosure; see the file-level results in [PUBLIC_REPOSITORY_SECURITY_REVIEW.md](PUBLIC_REPOSITORY_SECURITY_REVIEW.md). The release is intended to be safe to share **with its current evidence limits intact**. It is not a certification of the live lab, a full deployment export, or a guarantee about future additions.

Validation: three Bash scripts passed syntax checks; 17 behavioral tests passed and one non-root test was skipped. No live cleanup or home-network testing was performed. All artifacts are delivered without prior Git history.
