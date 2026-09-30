# Scripts

These scripts preserve the best-supported disk-monitoring and recovery logic from the lab.

## `health-check/disk_usage.sh`

Reads filesystem utilization for `DISK_PATH` (default `/`) and prints an integer percentage.

## `monitoring/disk_diagnose.sh`

Lists the largest first-level entries on the selected filesystem to support diagnosis when disk usage crosses the workflow threshold.

## `maintenance/disk_cleanup.sh`

Provides a bounded cleanup action for archived systemd journal data and the APT package cache.

The script defaults to `--dry-run`. Actual cleanup requires both `--apply` and root privileges.

## Verification

The recovery workflow checks disk usage again after cleanup. The cleanup command completing successfully is not treated as proof that the capacity issue is resolved.
