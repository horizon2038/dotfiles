#!/usr/bin/env bash

# Shared by the save, restore, and backup commands; compatible with Bash 3.2.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# shellcheck source=targets.sh
source "${SCRIPT_DIR}/targets.sh"

parse_options()
{
    DRY_RUN=false
    VERBOSE=false
    SHOW_HELP=false
    LIST_TARGETS=false
    SELECTED_OS=""
    POSITIONAL_ARGS=()

    while [ "$#" -gt 0 ]
    do
        case "$1" in
            --dry-run|-n) DRY_RUN=true ;;
            --verbose|-v) VERBOSE=true ;;
            --help|-h) SHOW_HELP=true ;;
            --list) LIST_TARGETS=true ;;
            --os)
                if [ "$#" -lt 2 ] || [ -z "$2" ]
                then
                    echo '--os requires macOS or Linux.' >&2
                    return 1
                fi
                SELECTED_OS="$2"
                shift
                ;;
            --os=)
                echo '--os requires macOS or Linux.' >&2
                return 1
                ;;
            --os=*) SELECTED_OS="${1#*=}" ;;
            --)
                shift
                POSITIONAL_ARGS+=("$@")
                break
                ;;
            -*)
                printf 'Unknown option: %s\n' "$1" >&2
                return 1
                ;;
            *) POSITIONAL_ARGS+=("$1") ;;
        esac
        shift
    done
}

load_targets()
{
    local detected_os="${SELECTED_OS}"
    if [ -z "${detected_os}" ]
    then
        detected_os="$(uname -s)"
    fi
    SELECTED_OS="$(normalize_os "${detected_os}")"
    select_targets "${SELECTED_OS}"
}

require_rsync()
{
    if ! command -v rsync >/dev/null 2>&1
    then
        echo 'rsync command not found. Install rsync and try again.' >&2
        return 1
    fi
}

path_exists()
{
    [ -e "$1" ] || [ -L "$1" ]
}

copy_target()
{
    local source_path="$1"
    local destination_path="$2"
    local dry_run="$3"
    shift 3
    local destination_parent="${destination_path%/*}"

    if [ "${dry_run}" = true ]
    then
        if [ -d "${destination_parent}" ]
        then
            rsync --dry-run "$@" -- "${source_path}" "${destination_parent}/"
        else
            # macOS openrsync may create implied directories with -Rn.
            # A missing parent means every source entry is new; list it using
            # the sender only, without starting a receiver or creating parents.
            printf '  Would create parent directory: %s\n' "${destination_parent}"
            rsync -a --list-only -- "${source_path}"
        fi
    else
        mkdir -p "${destination_parent}"
        # Omitting the source's trailing slash preserves top-level symlinks.
        # All registered targets have the same basename on both sides.
        rsync "$@" -- "${source_path}" "${destination_parent}/"
    fi
}

list_targets()
{
    local index
    printf 'OS: %s\n' "${SELECTED_OS}"
    for ((index = 0; index < ${#REPO_TARGETS[@]}; index++))
    do
        printf '  %s <-> $HOME/%s\n' "${REPO_TARGETS[index]}" "${HOME_TARGETS[index]}"
    done
}
