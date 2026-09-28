# n8n Monitoring & Recovery Automation — Portfolio Reference

> **Purpose:** A sanitized, GitHub-ready reference for a Linux home-lab monitoring and bounded-recovery project built with Ubuntu, CasaOS, Docker, n8n, SSH-based host checks, local logging, and Discord notifications.
>
> **Accuracy note:** This write-up is based on the home-lab work I actually completed. Where I still had the original commands, I kept them. Where I no longer had the exact n8n export or script, I documented what the workflow did instead of recreating it and calling it original.

---

## Project Overview

This project used **n8n as an orchestration layer** for Linux host-health monitoring.

```text
Monitor → Evaluate → Diagnose → Recover (when appropriate) → Verify → Log → Notify
```

The strongest best-preserved part of the project is the disk-capacity branch:

```text
Read disk usage
        ↓
Above 80%?
   ┌────┴────┐
   No       Yes
   ↓         ↓
Healthy   Diagnose
             ↓
          Cleanup
             ↓
           Verify
             ↓
        Log + Notify
```

Additional monitoring branches were built or discussed for CPU/temperature, RAM/swap, battery/AC, network health, system logs, application availability, and failed SSH attempts. Where the original executable code was not preserved, this document labels the branch as **documented behavior only**.

---

## 1. Disk Usage Check

### Original command used in the workflow

```bash
df -P / | tail -1 | awk '{print $5}' | tr -d '%'
```

The n8n decision branch treated usage **above 80%** as critical.

### Cleaned-up public version: `disk_usage.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail
export LC_ALL=C

if [[ ${1:-} == --help && $# -eq 1 ]]; then
    printf '%s\n' 'Usage: DISK_PATH=/ bash disk_usage.sh'
    exit 0
fi

if (( $# != 0 )); then
    printf '%s\n' 'Unexpected arguments; use --help.' >&2
    exit 2
fi

disk_path=${DISK_PATH:-/}

if [[ $disk_path != /* ]]; then
    printf '%s\n' 'DISK_PATH must be an absolute path.' >&2
    exit 2
fi

for dependency in df tail awk tr; do
    if ! command -v "$dependency" >/dev/null 2>&1; then
        printf 'Missing dependency: %s\n' "$dependency" >&2
        exit 1
    fi
done

if ! disk_percent=$(df -P -- "$disk_path" 2>/dev/null | tail -1 | awk '{print $5}' | tr -d '%'); then
    printf '%s\n' 'Could not read filesystem usage.' >&2
    exit 1
fi

if [[ ! $disk_percent =~ ^[0-9]{1,3}$ ]] || (( 10#$disk_percent > 100 )); then
    printf '%s\n' 'Filesystem usage was not a valid percentage.' >&2
    exit 1
fi

printf '%d\n' "$((10#$disk_percent))"
```

---

## 2. Disk Diagnosis

### Original command used in the workflow

```bash
du -xhd1 / 2>/dev/null | sort -h | tail -10
```

### Cleaned-up public version: `disk_diagnose.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail
export LC_ALL=C

if [[ ${1:-} == --help && $# -eq 1 ]]; then
    printf '%s\n' 'Usage: DISK_PATH=/ bash disk_diagnose.sh'
    exit 0
fi

if (( $# != 0 )); then
    printf '%s\n' 'Unexpected arguments; use --help.' >&2
    exit 2
fi

disk_path=${DISK_PATH:-/}

if [[ $disk_path != /* ]]; then
    printf '%s\n' 'DISK_PATH must be an absolute path.' >&2
    exit 2
fi

for dependency in du sort tail; do
    if ! command -v "$dependency" >/dev/null 2>&1; then
        printf 'Missing dependency: %s\n' "$dependency" >&2
        exit 1
    fi
done

scan_exit=0
sizes=$(du -xhd1 -- "$disk_path" 2>/dev/null) || scan_exit=1

if [[ -n $sizes ]]; then
    printf '%s\n' "$sizes" | sort -h | tail -10
fi

if (( scan_exit != 0 )); then
    printf '%s\n' 'Scan incomplete: some entries could not be read.' >&2
fi

exit "$scan_exit"
```

---

## 3. Bounded Disk Recovery

### Original recovery commands

```bash
set -e
journalctl --vacuum-time=7d
apt-get clean
```

The workflow then checked disk usage again rather than assuming cleanup solved the problem.

### Cleaned-up public version: `disk_cleanup.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

if (( $# > 1 )); then
    printf '%s\n' 'Expected at most one option; use --help.' >&2
    exit 2
fi

case ${1:---dry-run} in
    --help)
        printf '%s\n' \
            'Usage: bash disk_cleanup.sh [--dry-run|--apply]' \
            'Default: preview only. --apply requires root and removes journal/cache data.'
        exit 0
        ;;
    --dry-run)
        printf '%s\n' \
            'Preview only; no commands executed:' \
            'journalctl --vacuum-time=7d' \
            'apt-get clean'
        exit 0
        ;;
    --apply)
        ;;
    *)
        printf '%s\n' 'Unknown option; use --help.' >&2
        exit 2
        ;;
esac

if (( EUID != 0 )); then
    printf '%s\n' 'Apply requires root privileges; no cleanup performed.' >&2
    exit 1
fi

for dependency in journalctl apt-get; do
    if ! command -v "$dependency" >/dev/null 2>&1; then
        printf 'Missing dependency: %s; no cleanup performed.\n' "$dependency" >&2
        exit 1
    fi
done

printf '%s\n' 'Vacuuming eligible archived journal files.' >&2

if ! journalctl --vacuum-time=7d; then
    printf '%s\n' 'Journal cleanup failed; package-cache cleanup skipped.' >&2
    exit 1
fi

printf '%s\n' 'Cleaning downloaded APT package cache.' >&2

if ! apt-get clean; then
    printf '%s\n' 'Package-cache cleanup failed; journal cleanup already completed.' >&2
    exit 1
fi

printf '%s\n' 'Cleanup commands completed. Check disk usage again to verify the outcome.'
```

---

## 4. n8n Disk Workflow Reference

| Stage | Behavior |
|---|---|
| Trigger | Manual testing was used during construction |
| Monitor | SSH to Linux host and read root filesystem usage |
| Decision | Critical if usage was greater than 80% |
| Diagnose | Inspect first-level filesystem usage |
| Recover | Vacuum eligible archived journals, then clear APT package cache |
| Verify | Re-run disk usage check |
| Log | Record result to a local health log |
| Notify | Discord notification branch was tested |

I no longer have the full n8n JSON export for this workflow, so I’m not guessing at node IDs, credential references, expressions, retry settings, or exact wiring.

---

## 5. CPU & Temperature Monitoring

**Note:** I no longer have the original executable collector for this branch, so I’m documenting what it monitored rather than recreating the script from memory.

The project included CPU and temperature monitoring through host checks. Diagnostic work referenced CPU usage, process activity, load, and Linux thermal interfaces.

The original final threshold, complete shell collector, and exact n8n node configuration are not included because they were not preserved.

---

## 6. RAM & Swap Monitoring

**Note:** I no longer have the original executable collector for this branch, so I’m documenting what it monitored rather than recreating the script from memory.

The workflow included memory and swap percentage monitoring and verification.

A fair way to describe this work is:

> Built n8n host-health checks for RAM and swap usage, with threshold-based workflow branching and follow-up verification.

---

## 7. Battery & AC Monitoring

**Note:** I no longer have the original executable collector for this branch, so I’m documenting what it monitored rather than recreating the script from memory.

The monitoring branch tracked battery capacity, charging/discharging state, and AC power state.

A critical condition was described as:

```text
AC offline OR battery capacity below 20%
```

Typical Linux data sources include:

```text
/sys/class/power_supply/BAT0/
/sys/class/power_supply/BAT1/
/sys/class/power_supply/AC/
```

These are Linux interface examples, not a claim about the exact original command body.

---

## 8. Network Health Monitoring

**Note:** I still have the overall behavior from this branch, but not the complete original probe command.

The network branch checked active interface, default gateway, link state, gateway reachability, DNS reachability, and internet reachability.

The workflow used result fields such as:

```text
gateway_ok
dns_ok
internet_ok
```

---

## 9. System Log Monitoring

**Note:** I was able to recover part of this branch, including the command below.

Recovered command:

```bash
sleep 30
COUNT=$(journalctl -p 0..3 --since "30 seconds ago" --no-pager \
  | grep -v '^-- No entries --$' \
  | wc -l)

printf '{"error_count":%s}\n' "$COUNT"
```

The workflow used the result for branch logic and alerting.

---

## 10. Local Health Log

The n8n workflow wrote branch results to a local health log.

Historical form:

```text
/home/<user>/n8n-health.log
```

For a public repository, use a generic path and do not expose a real username or identifying filesystem path.

---

## 11. Discord Alerting

Discord notifications were used for tested health branches.

Never publish Discord webhook URLs, API tokens, credential IDs, or private message metadata.

Recommended representation:

```text
n8n workflow
    ↓
health decision
    ↓
Discord notification node
    ↓
credential stored privately in n8n
```

---

## 12. Application Availability Monitoring

Application availability was monitored separately from host-health checks.

Observed failure examples included:

```text
connect ECONNREFUSED <host>:<port>
socket hang up
```

and later:

```text
200 - OK
```

A controlled application-stop test exposed an incorrect monitoring target; after correcting the target, the expected DOWN state was detected. This is a useful example of validating monitoring with controlled failure tests rather than trusting a green dashboard by itself.

---

## 13. Failed SSH Login Monitoring

**Note:** This was part of the monitoring scope I wanted to build out, but I don’t have enough of the original implementation left to present it as completed code.

I’m not adding a replacement script here and pretending it was part of the original build.

---

## 14. SMART / Disk Health Monitoring

**Note:** This was part of the planned monitoring scope, but I don’t have enough of the original implementation left to present it as completed work.

I’m treating this as future work until I have a version I can actually show.

---

## 15. Local AI / Ollama Integration

The home lab also ran a local Ollama-based model and experimented with local AI tooling.

This project included local LLM hosting, API/UI troubleshooting, model connectivity testing, and monitoring-integration exploration.

A security-conscious architecture is:

```text
System telemetry
      ↓
n8n
      ↓
Local AI analysis
      ↓
Structured recommendation/report
      ↓
Allowlisted automation decision
      ↓
Approved recovery script
```

The key idea is that AI output should be treated as input for review or structured logic, not dropped directly into shell commands.

---

## 16. Security Controls for a Public Repository

Before publishing an n8n workflow export, I’d review it for:

- private IP addresses
- hostnames
- usernames
- personal filesystem paths
- Discord webhook URLs
- API keys/tokens
- n8n credential references
- pinned execution data
- workflow execution history
- internal endpoint URLs
- instance IDs
- personal node names/comments
- screenshots containing browser/session/account details

Recommended `.gitignore` entries:

```gitignore
.env
.env.*
!.env.example

*.log
*.bak
*.backup

credentials/
secrets/
private/

.n8n/
```

---

## 17. Suggested GitHub Directory Layout

```text
linux-monitoring-recovery-lab/
├── README.md
├── SECURITY.md
├── .gitignore
├── docs/
│   ├── architecture.md
│   ├── monitoring.md
│   ├── self-healing.md
│   └── lessons-learned.md
├── scripts/
│   ├── health-check/
│   │   └── disk_usage.sh
│   ├── monitoring/
│   │   └── disk_diagnose.sh
│   └── maintenance/
│       └── disk_cleanup.sh
└── config-examples/
    └── monitoring/
        └── n8n-disk-branch.md
```

---

## 18. Safe Usage

```bash
bash scripts/health-check/disk_usage.sh
DISK_PATH=/ bash scripts/monitoring/disk_diagnose.sh
bash scripts/maintenance/disk_cleanup.sh --dry-run
sudo bash scripts/maintenance/disk_cleanup.sh --apply
bash scripts/health-check/disk_usage.sh
```

A successful cleanup command does not prove the capacity issue is resolved. Verification is a separate step.

---

## 19. Skills Demonstrated

Linux administration · Bash · SSH-based host checks · Docker · CasaOS · n8n workflow automation · threshold-based monitoring · troubleshooting · controlled failure testing · local event logging · Discord alerting · bounded recovery · post-remediation verification · local AI hosting with Ollama · security-conscious automation design · infrastructure documentation

---

## 20. Portfolio Description

> Built a Linux home-lab monitoring and recovery platform using Ubuntu, CasaOS, Docker, and n8n. Implemented SSH-based host-health checks, threshold-driven workflow branches, local logging, Discord notifications, application availability monitoring, and a bounded disk-recovery workflow that diagnoses high filesystem usage, performs limited cleanup, and verifies the result. Also deployed and troubleshot local AI services with Ollama while keeping automated recovery actions allowlisted and separate from AI-generated output.

---

## 21. Project Notes

This repository reflects the work I completed in my home lab while learning Linux, Docker, n8n, monitoring, and automation.

The disk usage, disk diagnosis, and disk cleanup sections are based directly on the commands I used in the project, with a few extra safety checks added for a public repo.

Some of the original n8n exports and supporting scripts were not saved. For those parts, I documented what the workflow did instead of rebuilding it from memory and presenting it as the original.

I plan to keep adding to this project as I build out more monitoring, security logging, and automation work.
