#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd)"
DOTFILES_ROOT="$(cd "${SCRIPT_DIR}/.."; pwd)"

source "${SCRIPT_DIR}/targets.sh"

backup_targets()
{
    local source_root="$1"
    local label="$2"

    if ! command -v rsync >/dev/null 2>&1
    then
        echo "rsync command not found. Please install rsync to use this backup script."
        return 1
    fi

    local timestamp
    timestamp=$(date '+%Y%m%d-%H%M%S')

    local backup_root="${DOTFILES_ROOT}/backups"
    local backup_dir="${backup_root}/backup-${label}-${timestamp}"

    mkdir -p "${backup_dir}"

    # log
    echo "Backup destination: ${backup_dir}"
    echo "Backup source root: ${source_root}"
    echo "Targets to backup:"
    echo "Targets: ${#TARGETS[@]} item(s)"

    # perform backup
    local target
    for target in "${TARGETS[@]}"
    do
        local source_path="${source_root}/${target}"
        if [ -e "${source_path}" ]
        then
            rsync -aR "${source_path}" "${backup_dir}/"
        else
            echo " - ${source_path} does not exist. Skipping."
        fi
    done

    echo "Backup completed."
}

main()
{
    if [ "${1:-}" = "" ] || [ "${2:-}" = "" ]
    then
        echo "Usage: $0 <source_root> <label>" >&2
        exit 1
    fi

    backup_targets "$1" "$2"
}

if [ "${BASH_SOURCE[0]}" = "$0" ]
then
    main "$@"
fi
