# dotfiles

Dotfiles for macOS and Linux. Requires Bash and rsync.

`common/` holds shared settings; `macOS/` and `Linux/` hold OS-specific settings. The OS is detected automatically.

```bash
./scripts/sync_from_home.sh            # Save HOME to repo
./scripts/deploy_to_home.sh            # Restore repo to HOME
./scripts/deploy_to_home.sh --dry-run  # Preview changes
```

Register HOME-relative paths in `scripts/targets.sh`. OS-specific targets take precedence. Existing settings are backed up to `backups/` before changes.
