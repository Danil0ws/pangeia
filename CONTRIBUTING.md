# Contributing to Pangeia

Thanks for helping. Pangeia is a small project with a strict structure, so
there is not much to learn before your first pull request.

## Ground rules

- **Code and comments in English.** All of them, including shell comments,
  commit messages, and workflow names.
- **Translations are welcome** in any language that already has a README
  (`README.<lang>.md`, `docs/*.<lang>.md`). Keep the structure identical to
  the Portuguese source.
- **One change per pull request.** Small diffs get reviewed fast.
- **Never break a supported manager.** If your change touches detection or
  an adapter, add or update a test.

## Getting started

```bash
git clone https://github.com/Danil0ws/pangeia
cd pangeia
bash tests/run.sh
```

No dependencies are required — the tests are plain bash and run on any
Linux, on macOS, and in the GitHub Actions matrix.

## Where things live

| Path | Responsibility |
|---|---|
| `src/domain/` | Pure decisions: manager detection, package-name mapping and the command vocabulary |
| `src/adapters/` | One file per package manager, five functions each |
| `src/application/` | Use cases that orchestrate domain + adapters |
| `src/cli.sh` | Argument parsing and user-facing output |
| `bin/pangeia` | Entry point that wires the layers together |
| `shell/pangeia.sh` | Shell integration sourced from `.bashrc`/`.zshrc` |
| `tests/` | The test suite and its tiny harness |

### Adding a package manager

1. Create `src/adapters/<name>.sh`.
2. Implement `pangeia_adapter_install`, `pangeia_adapter_remove`,
   `pangeia_adapter_search`, `pangeia_adapter_update` and
   `pangeia_adapter_version`. Use `pangeia_run` so dry-run mode and privilege
   escalation keep working, and `pangeia_query` for read-only commands.
3. Return the id from `pangeia_detect_manager` in `src/domain/detect.sh`,
   **in the right order** (atomic systems first).
4. Add cases to `tests/test_adapters.sh` and `tests/test_detect.sh`.

### Adding a package-name mapping

Add one arm to `pangeia_package_name` in `src/domain/mapping.sh` and a case
to `tests/test_mapping.sh`.

### Adding a command spelling

Add the word to the right line of `_pangeia_action_table` in
`src/domain/commands.sh`. Normalization, the typo suggestions and
`tests/test_commands.sh` all read that table, so nothing else changes.

## Style

- POSIX-friendly bash, compatible with bash 3.2 (macOS).
- `shellcheck` clean, `shfmt -i 4 -ci` formatted (the same flags CI uses —
  run `make fmt` and `make lint` before pushing).
- Quote expansions; use `pangeia_run` (or `pangeia_query` for read-only
  commands) instead of calling tools directly, so dry-run keeps working.
- Prefer deletion over addition. If a feature is not needed today, it does
  not go in.

## Tests

```bash
bash tests/run.sh          # everything
bash tests/test_adapters.sh  # one file
```

Coverage expectations: any change to detection, mapping, an adapter, or the
CLI needs a matching test. In dry-run mode adapters print the exact command,
which is what the assertions check — so a test never needs root or a real
package manager.

## Commits and releases

Pangeia uses [Conventional Commits](https://www.conventionalcommits.org/)
(`feat:`, `fix:`, `docs:`, `chore:`). Version numbers and `CHANGELOG.md` are
generated automatically from those messages on `main`, and a release is
published on every version bump — you never edit the version by hand.

## Code of conduct

By participating you agree to the
[Code of Conduct](CODE_OF_CONDUCT.md).

## License

Contributions are released under the MIT license — see [LICENSE](LICENSE).
