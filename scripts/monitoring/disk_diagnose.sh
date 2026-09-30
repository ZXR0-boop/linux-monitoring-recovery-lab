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
