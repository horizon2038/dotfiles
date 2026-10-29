#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=sync_targets.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/sync_targets.sh"

sync_dotfiles Restore "$@"

