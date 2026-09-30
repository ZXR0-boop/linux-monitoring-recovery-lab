#!/usr/bin/env bash
set -euo pipefail

if (( $# > 1 )); then
    printf '%s\n' 'Expected at most one option; use --help.' >&2
    exit 2
fi

case ${1:---dry-run} in
    --help)
        printf '%s\n'             'Usage: bash disk_cleanup.sh [--dry-run|--apply]'             'Default: preview only. --apply requires root and removes journal/cache data.'
        exit 0
        ;;
    --dry-run)
        printf '%s\n'             'Preview only; no commands executed:'             'journalctl --vacuum-time=7d'             'apt-get clean'
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
