"""Exercise save/restore only in temporary repositories and HOME directories."""

import os
from pathlib import Path
import shutil
import stat
import subprocess
import tempfile
import unittest


SCRIPTS = Path(__file__).resolve().parents[1] / "scripts"
BASH = os.environ.get("DOTFILES_TEST_BASH", "/bin/bash")


class SyncScriptsTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="dotfiles tests ")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.repo = self.root / "dotfiles repo"
        self.home = self.root / "test home"
        shutil.copytree(SCRIPTS, self.repo / "scripts")
        for group in ("common", "macOS", "Linux"):
            (self.repo / group).mkdir()
        self.home.mkdir()
        self.write(self.repo / "common/.wezterm.lua", "shared original\n")
        self.write(self.repo / "macOS/.zshrc", "mac original\n")
        self.write(self.home / ".wezterm.lua", "home current configuration\n")
        self.write(self.home / ".zshrc", "home zsh current configuration\n")
        self.env = {**os.environ, "HOME": str(self.home)}

    @staticmethod
    def write(path, content):
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content)

    def run_script(self, script, *args, success=True, env=None):
        result = subprocess.run(
            [BASH, str(self.repo / "scripts" / script), *map(str, args)],
            cwd=self.root,
            env=self.env if env is None else env,
            capture_output=True,
            text=True,
            timeout=30,
        )
        if success:
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        else:
            self.assertNotEqual(result.returncode, 0, result.stdout + result.stderr)
        return result

    def snapshot(self):
        result = {}
        for path in self.root.rglob("*"):
            info = path.lstat()
            content = None
            if path.is_symlink():
                content = os.readlink(path)
            elif path.is_file():
                content = path.read_bytes()
            result[str(path.relative_to(self.root))] = (
                info.st_mode,
                info.st_mtime_ns,
                content,
            )
        return result

    def backup(self, label):
        matches = list((self.repo / "backups").glob(f"backup-{label}-*"))
        self.assertEqual(len(matches), 1)
        return matches[0]

    def tool(self, name, body):
        path = self.root / "tools" / name
        self.write(path, "#!/bin/sh\n" + body + "\n")
        path.chmod(0o755)
        self.env["PATH"] = str(path.parent) + os.pathsep + os.environ["PATH"]

    def test_save_groups_files_and_backs_up_previous_repository(self):
        self.write(self.home / ".config/nvim/init.lua", "new nvim config\n")
        executable = self.home / ".config/nvim/tool.sh"
        self.write(executable, "#!/bin/sh\nexit 0\n")
        executable.chmod(0o755)
        self.write(self.repo / "common/.config/nvim/extra.lua", "keep this\n")
        self.run_script("sync_from_home.sh", "--os", "macOS")
        self.assertEqual(
            (self.repo / "common/.wezterm.lua").read_text(),
            "home current configuration\n",
        )
        self.assertEqual(
            (self.repo / "macOS/.zshrc").read_text(),
            "home zsh current configuration\n",
        )
        self.assertEqual(
            (self.repo / "common/.config/nvim/init.lua").read_text(),
            "new nvim config\n",
        )
        self.assertTrue((self.repo / "common/.config/nvim/extra.lua").is_file())
        self.assertEqual(
            stat.S_IMODE((self.repo / "common/.config/nvim/tool.sh").stat().st_mode),
            0o755,
        )
        backup = self.backup("repo_before_sync")
        self.assertEqual((backup / "common/.wezterm.lua").read_text(), "shared original\n")
        self.assertEqual((backup / "macOS/.zshrc").read_text(), "mac original\n")
        self.assertFalse((backup / "Users").exists())

    def test_restore_backs_up_home_and_keeps_unmanaged_files(self):
        self.write(self.repo / "common/.config/nvim/init.lua", "restored nvim\n")
        self.write(self.home / ".config/nvim/local.lua", "keep local\n")
        self.run_script("deploy_to_home.sh", "--os", "macOS")
        self.assertEqual((self.home / ".wezterm.lua").read_text(), "shared original\n")
        self.assertEqual((self.home / ".zshrc").read_text(), "mac original\n")
        self.assertEqual((self.home / ".config/nvim/init.lua").read_text(), "restored nvim\n")
        self.assertEqual((self.home / ".config/nvim/local.lua").read_text(), "keep local\n")
        backup = self.backup("home_before_deploy")
        self.assertEqual((backup / ".wezterm.lua").read_text(), "home current configuration\n")
        self.assertEqual((backup / ".config/nvim/local.lua").read_text(), "keep local\n")

    def test_dry_run_creates_no_files_directories_or_backups(self):
        self.write(self.home / ".config/nvim/new.lua", "only in home\n")
        self.write(self.repo / "macOS/.config/sketchybar/sketchybarrc", "only in repo\n")
        for script in ("sync_from_home.sh", "deploy_to_home.sh"):
            with self.subTest(script=script):
                before = self.snapshot()
                result = self.run_script(script, "--os", "macOS", "--dry-run", "--verbose")
                self.assertEqual(self.snapshot(), before)
                self.assertIn("Dry run completed.", result.stdout)
        self.assertFalse((self.repo / "backups").exists())

    def test_linux_ignores_mac_files_in_both_directions(self):
        self.run_script("sync_from_home.sh", "--os", "Linux")
        self.assertEqual((self.repo / "macOS/.zshrc").read_text(), "mac original\n")
        self.write(self.home / ".zshrc", "linux only\n")
        self.run_script("deploy_to_home.sh", "--os=linux")
        self.assertEqual((self.home / ".zshrc").read_text(), "linux only\n")
        self.assertFalse((self.backup("repo_before_sync") / "macOS").exists())
        self.assertFalse((self.backup("home_before_deploy") / ".zshrc").exists())

    def test_os_override_does_not_overwrite_common_when_saving(self):
        manifest = self.repo / "scripts/targets.sh"
        with manifest.open("a") as stream:
            stream.write('\nMACOS_TARGETS+=(".wezterm.lua")\n')
        self.write(self.repo / "macOS/.wezterm.lua", "mac-specific original\n")
        self.run_script("sync_from_home.sh", "--os", "macOS")
        self.assertEqual((self.repo / "common/.wezterm.lua").read_text(), "shared original\n")
        self.assertEqual(
            (self.repo / "macOS/.wezterm.lua").read_text(), "home current configuration\n"
        )
        self.write(self.home / ".wezterm.lua", "different home contents\n")
        self.run_script("deploy_to_home.sh", "--os", "macOS")
        self.assertEqual((self.home / ".wezterm.lua").read_text(), "home current configuration\n")
        backup = self.backup("repo_before_sync")
        self.assertEqual((backup / "macOS/.wezterm.lua").read_text(), "mac-specific original\n")
        self.assertFalse((backup / "common/.wezterm.lua").exists())

    def test_auto_detection_selects_only_current_os(self):
        for detected, expected in (("Darwin", "macOS"), ("Linux", "Linux")):
            with self.subTest(detected=detected):
                self.tool("uname", f"printf '%s\\n' '{detected}'")
                result = self.run_script("deploy_to_home.sh", "--list")
                self.assertIn(f"OS: {expected}", result.stdout)
                self.assertEqual("macOS/.zshrc" in result.stdout, expected == "macOS")

    def test_help_list_and_invalid_options_do_not_write(self):
        before = self.snapshot()
        for script in ("sync_from_home.sh", "deploy_to_home.sh", "backup_targets.sh"):
            self.run_script(script, "--help")
            self.run_script(script, "--list", "--os", "Linux")
            self.run_script(script, "--unknown", success=False)
            self.run_script(script, "--os", success=False)
            self.run_script(script, "--os=", success=False)
            self.run_script(script, "--os", "unsupported", success=False)
        self.assertEqual(self.snapshot(), before)

    def test_unique_relative_backups_preserve_dangling_symlinks(self):
        self.tool("date", "printf '%s\\n' '20000101-000000'")
        link = self.home / ".wezterm.lua"
        link.unlink()
        link.symlink_to("missing-config.lua")
        for _ in range(2):
            self.run_script("backup_targets.sh", "--os", "macOS", self.home, "snapshot")
        backups = list((self.repo / "backups").iterdir())
        self.assertEqual(len(backups), 2)
        for backup in backups:
            self.assertTrue(backup.name.startswith("backup-snapshot-20000101-000000-"))
            self.assertEqual(os.readlink(backup / ".wezterm.lua"), "missing-config.lua")
            self.assertEqual((backup / ".zshrc").read_text(), "home zsh current configuration\n")

    def test_standalone_backup_repo_layout_and_dry_run(self):
        before = self.snapshot()
        self.run_script("backup_targets.sh", "--os", "macOS", "--dry-run", self.repo, "repo")
        self.assertEqual(self.snapshot(), before)
        self.run_script("backup_targets.sh", "--os", "macOS", self.repo, "repo")
        self.assertEqual((self.backup("repo") / "common/.wezterm.lua").read_text(), "shared original\n")

    def test_backup_failure_stops_before_overwriting_destination(self):
        self.tool("rsync", "exit 73")
        result = self.run_script("deploy_to_home.sh", "--os", "macOS", success=False)
        self.assertEqual(result.returncode, 73)
        self.assertEqual((self.home / ".wezterm.lua").read_text(), "home current configuration\n")
        self.assertEqual((self.home / ".zshrc").read_text(), "home zsh current configuration\n")
        self.assertNotIn("Restore completed.", result.stdout)

    def test_same_file_is_skipped_instead_of_replacing_it_with_a_symlink(self):
        link = self.home / ".wezterm.lua"
        link.unlink()
        link.symlink_to(self.repo / "common/.wezterm.lua")
        result = self.run_script("sync_from_home.sh", "--os", "macOS")
        self.assertIn("Same file, skipping:", result.stdout)
        self.assertFalse((self.repo / "common/.wezterm.lua").is_symlink())
        self.assertEqual((self.repo / "common/.wezterm.lua").read_text(), "shared original\n")

    def test_restore_keeps_symlinked_parent_directory(self):
        self.write(self.repo / "common/.config/nvim/init.lua", "nvim via parent link\n")
        external = self.root / "config elsewhere"
        external.mkdir()
        (self.home / ".config").symlink_to(external, target_is_directory=True)
        self.run_script("deploy_to_home.sh", "--os", "macOS")
        self.assertTrue((self.home / ".config").is_symlink())
        self.assertEqual((external / "nvim/init.lua").read_text(), "nvim via parent link\n")

    def test_same_size_and_timestamp_changes_are_copied(self):
        repo_path = self.repo / "common/.wezterm.lua"
        home_path = self.home / ".wezterm.lua"
        for script, source, destination in (
            ("sync_from_home.sh", home_path, repo_path),
            ("deploy_to_home.sh", repo_path, home_path),
        ):
            with self.subTest(script=script):
                self.write(source, "new configuration\n")
                self.write(destination, "old configuration\n")
                for path in (source, destination):
                    os.utime(path, (1600000000, 1600000000))
                self.run_script(script, "--os", "macOS")
                self.assertEqual(destination.read_text(), "new configuration\n")

    def test_invalid_or_overlapping_targets_fail_before_writing(self):
        manifest = self.repo / "scripts/targets.sh"
        original = manifest.read_text()
        for target in ("../escape", "/absolute", ".config/nvim/init.lua"):
            with self.subTest(target=target):
                manifest.write_text(original + f'\nMACOS_TARGETS+=("{target}")\n')
                before = self.snapshot()
                for script in ("sync_from_home.sh", "deploy_to_home.sh"):
                    self.run_script(script, "--os", "macOS", success=False)
                self.assertEqual(self.snapshot(), before)

    def test_empty_target_lists_are_a_no_op(self):
        manifest = self.repo / "scripts/targets.sh"
        with manifest.open("a") as stream:
            stream.write("\nCOMMON_TARGETS=()\nMACOS_TARGETS=()\n")
        before = self.snapshot()
        self.run_script("sync_from_home.sh", "--os", "macOS")
        self.run_script("deploy_to_home.sh", "--os", "macOS")
        self.run_script("backup_targets.sh", "--os", "macOS", self.home, "empty")
        self.assertEqual(self.snapshot(), before)

    def test_home_with_common_directory_still_uses_home_backup_layout(self):
        (self.home / "common").mkdir()
        self.run_script("backup_targets.sh", "--os", "macOS", self.home, "home")
        self.assertEqual(
            (self.backup("home") / ".wezterm.lua").read_text(),
            "home current configuration\n",
        )


if __name__ == "__main__":
    unittest.main()
