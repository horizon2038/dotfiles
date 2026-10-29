#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

backup_targets()
{
    local source_root="$1"
    local label="$2"
    local dry_run="$3"
    shift 3

    require_rsync
    if [ ! -d "${source_root}" ]
    then
        printf 'Backup source is not a directory: %s\n' "${source_root}" >&2
        return 1
    fi
    case "${label}" in
        ''|*[!a-zA-Z0-9_-]*)
            echo 'Backup label must contain only letters, numbers, underscores, or hyphens.' >&2
            return 1
            ;;
    esac

    if [ "${dry_run}" = true ]
    then
        printf 'Dry run: backup skipped (%s, %s).\n' "${source_root}" "${label}"
        return
    fi

    local backup_root="${DOTFILES_ROOT}/backups"
    local backup_dir timestamp target
    timestamp="$(date '+%Y%m%d-%H%M%S')"
    mkdir -p "${backup_root}"
    # A unique suffix prevents consecutive runs from merging snapshots.
    backup_dir="$(mktemp -d "${backup_root}/backup-${label}-${timestamp}-XXXXXX")"
    printf 'Backup destination: %s\n' "${backup_dir}"

    for target in "$@"
    do
        if path_exists "${source_root}/${target}"
        then
            copy_target "${source_root}/${target}" "${backup_dir}/${target}" false -a
        else
            printf '  Missing, skipping: %s\n' "${source_root}/${target}"
        fi
    done
    echo 'Backup completed.'
}

backup_usage()
{
    cat <<EOF
Usage: ${0##*/} [options] <source_root> <label>

Back up selected HOME paths, or grouped paths when source_root is this repo.

  --os <OS>       macOS or Linux (default: detected OS)
  --dry-run, -n   Show the plan without writing files or backups
  --list          List selected paths without writing files
  --help, -h      Show this help
EOF
}

main()
{
    parse_options "$@"
    if [ "${SHOW_HELP}" = true ]
    then
        backup_usage
        return
    fi
    load_targets
    if [ "${LIST_TARGETS}" = true ]
    then
        list_targets
        return
    fi
    if [ "${#POSITIONAL_ARGS[@]}" -ne 2 ]
    then
        backup_usage >&2
        return 1
    fi
    if [ "${#REPO_TARGETS[@]}" -eq 0 ]
    then
        printf 'No targets configured for %s.\n' "${SELECTED_OS}"
        return
    fi

    local source_root
    source_root="$(cd "${POSITIONAL_ARGS[0]}" && pwd -P)"
    if [ "${source_root}" -ef "${DOTFILES_ROOT}" ]
    then
        backup_targets "${source_root}" "${POSITIONAL_ARGS[1]}" "${DRY_RUN}" "${REPO_TARGETS[@]}"
    else
        backup_targets "${source_root}" "${POSITIONAL_ARGS[1]}" "${DRY_RUN}" "${HOME_TARGETS[@]}"
    fi
}

if [ "${BASH_SOURCE[0]}" = "$0" ]
then
    main "$@"
fi
