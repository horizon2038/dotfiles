#!/usr/bin/env bash
set -euo pipefail

# dry-run and verbose options
RSYNC_FLAGS=(
    -a
)

RSYNC_DIR_FLAGS=(
    -a
)

DRY_RUN=false
VERBOSE=false

while [ $# -gt 0 ]
do
    case "$1" in
        --dry-run)
            DRY_RUN=true
            ;;
        --verbose|-v)
            VERBOSE=true
            ;;
        *)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
    esac
    shift
done

if [ "${DRY_RUN}" = true ]
then
    RSYNC_FLAGS+=(-n)
    RSYNC_DIR_FLAGS+=(-n)
fi

if [ "${VERBOSE}" = true ]
then
    RSYNC_FLAGS+=(-v)
    RSYNC_DIR_FLAGS+=(-v)
fi


SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# shellcheck source=/dev/null
source "${SCRIPT_DIR}/targets.sh"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/backup_targets.sh"

deploy_one()
{
    local source_path="$1"   # repo 側の実体
    local destination_path="$2"  # HOME 側の配置先（フルパス）

    if [ -d "${source_path}" ]
    then
        mkdir -p "${destination_path%/*}"
        rsync "${RSYNC_DIR_FLAGS[@]}" "${source_path}/" "${destination_path}/"
    else
        mkdir -p "${destination_path%/*}"
        rsync "${RSYNC_FLAGS[@]}" "${source_path}" "${destination_path}"
    fi
}

main()
{
    backup_targets "${HOME}" "home_before_deploy"

    local target
    for target in "${TARGETS[@]}"
    do
        local source_path="${DOTFILES_ROOT}/${target}"
        local destination_path="${HOME}/${target}"

        if [ -e "${source_path}" ]
        then
            deploy_one "${source_path}" "${destination_path}"
        else
            echo " - ${source_path} does not exist in repo. Skipping."
        fi
    done

    echo "Deploy completed."
}

main "$@"

