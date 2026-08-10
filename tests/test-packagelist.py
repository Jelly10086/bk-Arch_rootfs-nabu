#!/usr/bin/env python3

import os
from pathlib import Path
import subprocess
import tempfile
import unittest


SCRIPT = Path(__file__).parents[1] / "packages/bk-packagelist/files/usr/bin/bk-packagelist"


class PackageListTests(unittest.TestCase):
    def run_tool(self, directory: Path, *args: str) -> subprocess.CompletedProcess[str]:
        environment = os.environ.copy()
        environment["BK_PACKAGE_LIST_DIR"] = str(directory)
        return subprocess.run(
            [str(SCRIPT), *args], capture_output=True, text=True, env=environment
        )

    def test_multiple_profiles_are_stably_deduplicated(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            directory = Path(temporary)
            (directory / "base").write_text("alpha\n# note\nbeta # inline\n")
            (directory / "cli").write_text("beta\n\ngamma\n")
            result = self.run_tool(directory, "base", "cli")
            self.assertEqual(result.returncode, 0)
            self.assertEqual(result.stdout, "alpha\nbeta\ngamma\n")

    def test_unknown_profile_fails(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            result = self.run_tool(Path(temporary), "missing")
            self.assertNotEqual(result.returncode, 0)
            self.assertIn("unknown profile: missing", result.stderr)

    def test_list_is_sorted(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            directory = Path(temporary)
            (directory / "zeta").touch()
            (directory / "alpha").touch()
            result = self.run_tool(directory, "--list")
            self.assertEqual(result.stdout, "alpha\nzeta\n")


if __name__ == "__main__":
    unittest.main()
