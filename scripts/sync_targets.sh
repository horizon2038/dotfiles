#!/usr/bin/env bash

# shellcheck source=backup_targets.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/backup_targets.sh"

sync_usage()
{
    local operation="$1"
    cat <<EOF
Usage: ${0##*/} [options]

${operation} dotfiles using common/ and the selected OS directory.
Existing destination settings are backed up before changes. Extra files are kept.

  --os <OS>       macOS or Linux (default: detected OS)
  --dry-run, -n   Show changes without writing files or backups
  --verbose, -v   Show verbose rsync output
  --list          List repository and HOME paths without writing files
  --help, -h      Show this help
EOF
}

sync_dotfiles()
{
    local operation="$1"
    shift
    parse_options "$@"
    if [ "${SHOW_HELP}" = true ]
    then
        sync_usage "${operation}"
        return
    fi
    if [ "${#POSITIONAL_ARGS[@]}" -ne 0 ]
    then
        sync_usage "${operation}" >&2
        return 1
    fi
    load_targets
    if [ "${LIST_TARGETS}" = true ]
    then
        list_targets
        return
    fi
    if [ "${#REPO_TARGETS[@]}" -eq 0 ]
    then
        printf 'No targets configured for %s.\n' "${SELECTED_OS}"
        return
    fi

    require_rsync
    if [ -z "${HOME:-}" ] || [ ! -d "${HOME}" ]
    then
        echo 'HOME must name an existing directory.' >&2
        return 1
    fi

    local home_root
    home_root="$(cd "${HOME}" && pwd -P)"
    if [ "${home_root}" -ef "${DOTFILES_ROOT}" ]
    then
        echo 'HOME and the dotfiles repository must be different directories.' >&2
        return 1
    fi

    # Config files can change without their size or timestamp changing.
    local rsync_flags=(-a --checksum --itemize-changes)
    if [ "${DRY_RUN}" = true ]
    then
        echo 'Dry run: no files or backups will be written.'
    fi
    if [ "${VERBOSE}" = true ]
    then
        rsync_flags+=(-v)
    fi

    printf '%s dotfiles (OS: %s).\n' "${operation}" "${SELECTED_OS}"
    if [ "${operation}" = Save ]
    then
        backup_targets "${DOTFILES_ROOT}" repo_before_sync "${DRY_RUN}" "${REPO_TARGETS[@]}"
    else
        backup_targets "${home_root}" home_before_deploy "${DRY_RUN}" "${HOME_TARGETS[@]}"
    fi

    local index source_path destination_path
    for ((index = 0; index < ${#REPO_TARGETS[@]}; index++))
    do
        if [ "${operation}" = Save ]
        then
            source_path="${home_root}/${HOME_TARGETS[index]}"
            destination_path="${DOTFILES_ROOT}/${REPO_TARGETS[index]}"
        else
            source_path="${DOTFILES_ROOT}/${REPO_TARGETS[index]}"
            destination_path="${home_root}/${HOME_TARGETS[index]}"
        fi

        if ! path_exists "${source_path}"
        then
            printf '  Missing, skipping: %s\n' "${source_path}"
            continue
        fi
        if [ "${source_path}" -ef "${destination_path}" ]
        then
            printf '  Same file, skipping: %s\n' "${source_path}"
            continue
        fi

        printf '  %s -> %s\n' "${source_path}" "${destination_path}"
        copy_target "${source_path}" "${destination_path}" "${DRY_RUN}" "${rsync_flags[@]}"
    done

    if [ "${DRY_RUN}" = true ]
    then
        echo 'Dry run completed.'
    else
        printf '%s completed.\n' "${operation}"
    fi
}
