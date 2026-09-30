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
