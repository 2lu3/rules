import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
PROFILE_FILES = {
    'research': 'research-code.md',
    'prototype': 'prototype-code.md',
    'app': 'app-code.md',
}


class InstallTest(unittest.TestCase):
    def setUp(self):
        self.workspace = tempfile.TemporaryDirectory(prefix='rules install test ')
        self.addCleanup(self.workspace.cleanup)
        self.root = Path(self.workspace.name)
        self.source = self.root / 'source'
        self.source.mkdir()
        for name in (
            'AGENTS.md', '.pre-commit-config.yaml', '.github',
            'scripts', '.agents', 'docs',
        ):
            original = ROOT / name
            if original.is_dir():
                shutil.copytree(original, self.source / name)
            else:
                shutil.copy2(original, self.source / name)
        self.target = self.root / 'target'
        self.target.mkdir()
        (self.target / 'docs').mkdir()
        (self.target / 'docs/project.md').write_text('Project documentation\n')
        (self.target / 'AGENTS.md').write_text('Original instructions\n')
        self.bin = self.root / 'bin'
        self.bin.mkdir()
        self.command('git', '''
import os
from pathlib import Path
import shutil
import sys
if sys.argv[1:] == ['rev-parse', '--show-toplevel']:
    print(os.environ['TEST_TARGET'])
elif sys.argv[1:2] == ['clone']:
    shutil.copytree(os.environ['TEST_SOURCE'], sys.argv[-1])
else:
    sys.exit(1)
''')
        self.command('pre-commit', '''
import os
from pathlib import Path
import sys
assert sys.argv[1:] == ['install', '--install-hooks']
Path(os.environ['TEST_TARGET'], 'hook-installed').touch()
''')
        self.env = {
            **os.environ,
            'PATH': str(self.bin) + os.pathsep + os.environ['PATH'],
            'TEST_SOURCE': str(self.source),
            'TEST_TARGET': str(self.target),
        }

    def command(self, name, body):
        path = self.bin / name
        path.write_text(f'#!{sys.executable}\n' + body)
        path.chmod(0o755)

    def install(self, *args):
        return subprocess.run(
            ['sh', str(ROOT / 'install.sh'), *args],
            cwd=self.target, env=self.env, capture_output=True, text=True,
        )

    def snapshot(self):
        return {
            str(p.relative_to(self.target)): p.read_bytes()
            for p in self.target.rglob('*') if p.is_file()
        }

    def assert_links_exist(self):
        agents = (self.target / 'AGENTS.md').read_text()
        for link in re.findall(r'\]\(([^)]+)\)', agents):
            self.assertTrue((self.target / link).is_file(), link)
        for rule in (self.target / 'docs/agents').glob('*.md'):
            self.assertIn(f'(docs/agents/{rule.name})', agents)

    def test_profiles_and_switching(self):
        common = {
            p.name for p in (self.source / 'docs/agents').glob('*.md')
        } - set(PROFILE_FILES.values())
        for profile, rule in PROFILE_FILES.items():
            with self.subTest(profile=profile):
                result = self.install('--profile', profile)
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertIn(f'profile: {profile}', result.stdout)
                installed = {
                    p.name for p in (self.target / 'docs/agents').glob('*.md')
                }
                self.assertEqual(installed, common | {rule})
                self.assert_links_exist()
                self.assertIn(
                    f'適用用途: `{profile}`',
                    (self.target / 'AGENTS.md').read_text(),
                )
                self.assertEqual(
                    (self.target / 'docs/project.md').read_text(),
                    'Project documentation\n',
                )
                self.assertTrue((self.target / 'hook-installed').exists())
                self.assertTrue(os.access(
                    self.target / 'scripts/setup-worktree.sh', os.X_OK,
                ))
                self.assertEqual(
                    (self.target / '.agents/skills/ship/SKILL.md').read_bytes(),
                    (self.target / '.claude/skills/ship/SKILL.md').read_bytes(),
                )

    def test_multiple_scopes(self):
        (self.source / 'docs/agents/shared.md').write_text(
            '---\napplies_to: [research, prototype]\n---\n\n# Shared\n',
        )
        with (self.source / 'AGENTS.md').open('a') as file:
            file.write('- [Shared](docs/agents/shared.md): Shared rules\n')
        for profile in PROFILE_FILES:
            with self.subTest(profile=profile):
                result = self.install('--profile', profile)
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual(
                    (self.target / 'docs/agents/shared.md').exists(),
                    profile in ('research', 'prototype'),
                )
                self.assert_links_exist()

    def test_invalid_metadata_does_not_modify_target(self):
        before = self.snapshot()
        for metadata in (
            '# Missing frontmatter\n',
            '---\ntitle: Missing scope\n---\n',
            '---\napplies_to: [research]\n',
            '---\napplies_to: [common]\n---\n',
            '---\napplies_to: []\n---\n',
            '---\napplies_to: [research, unknown]\n---\n',
            '---\napplies_to: [all]\napplies_to: [research]\n---\n',
            '---\napplies_to: research\n---\n',
            '---\napplies_to:\n  - research\n---\n',
            '---\napplies_to: ["research"]\n---\n',
        ):
            with self.subTest(metadata=metadata):
                (self.source / 'docs/agents/prototype-code.md').write_text(metadata)
                result = self.install('--profile', 'research')
                self.assertNotEqual(result.returncode, 0)
                self.assertIn('invalid applies_to frontmatter', result.stderr)
                self.assertEqual(self.snapshot(), before)

    def test_arguments_are_validated_before_installation(self):
        before = self.snapshot()
        for args in (
            (), ('--profile',), ('--profile', 'all'),
            ('--profile', 'unknown'), ('--other', 'research'),
            ('--profile', 'app', 'extra'),
        ):
            with self.subTest(args=args):
                self.assertNotEqual(self.install(*args).returncode, 0)
                self.assertEqual(self.snapshot(), before)
        for option in ('--help', '-h'):
            with self.subTest(option=option):
                result = self.install(option)
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertIn('--profile research|prototype|app', result.stdout)
                self.assertEqual(self.snapshot(), before)


if __name__ == '__main__':
    unittest.main()
