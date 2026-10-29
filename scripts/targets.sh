#!/usr/bin/env bash

set -euo pipefail

# Paths are relative to HOME. Add a target here and put its configuration in
# the corresponding common/, macOS/, or Linux/ directory.
COMMON_TARGETS=(
    ".wezterm.lua"
    ".tmux.conf"
    ".config/nvim"
)

MACOS_TARGETS=(
    ".zshrc"
    ".yabairc"
    ".skhdrc"
    ".config/sketchybar"
)

LINUX_TARGETS=()

normalize_os()
{
    case "$1" in
        Darwin|macOS|macos) printf '%s\n' macOS ;;
        Linux|linux) printf '%s\n' Linux ;;
        *)
            printf 'Unsupported OS: %s. Use --os macOS or Linux.\n' "$1" >&2
            return 1
            ;;
    esac
}

select_targets()
{
    local os="$1"
    local os_targets=()
    case "${os}" in
        macOS) os_targets=("${MACOS_TARGETS[@]-}") ;;
        Linux) os_targets=("${LINUX_TARGETS[@]-}") ;;
        *) return 1 ;;
    esac

    REPO_TARGETS=()
    HOME_TARGETS=()
    local target os_target overridden
    for target in "${COMMON_TARGETS[@]-}"
    do
        [ -n "${target}" ] || continue
        overridden=false
        for os_target in "${os_targets[@]-}"
        do
            if [ "${target}" = "${os_target}" ]
            then
                overridden=true
                break
            fi
        done
        if [ "${overridden}" = false ]
        then
            REPO_TARGETS+=("common/${target}")
            HOME_TARGETS+=("${target}")
        fi
    done

    # An OS-specific target owns the entire path. Saving an override must not
    # write machine-specific settings back into common/.
    for target in "${os_targets[@]-}"
    do
        [ -n "${target}" ] || continue
        REPO_TARGETS+=("${os}/${target}")
        HOME_TARGETS+=("${target}")
    done

    local index previous
    for ((index = 0; index < ${#HOME_TARGETS[@]}; index++))
    do
        target="${HOME_TARGETS[index]}"
        case "${target}" in
            /*|.|./*|*/./*|*/.|..|../*|*/../*|*/..|*/)
                printf 'Target must be a HOME-relative path without dot segments or a trailing slash: %s\n' "${target}" >&2
                return 1
                ;;
        esac
        for ((previous = 0; previous < index; previous++))
        do
            case "${target}/" in
                "${HOME_TARGETS[previous]}/"*)
                    printf 'Overlapping targets: %s and %s\n' "${HOME_TARGETS[previous]}" "${target}" >&2
                    return 1
                    ;;
            esac
            case "${HOME_TARGETS[previous]}/" in
                "${target}/"*)
                    printf 'Overlapping targets: %s and %s\n' "${target}" "${HOME_TARGETS[previous]}" >&2
                    return 1
                    ;;
            esac
        done
    done
}
