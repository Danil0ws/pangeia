# Contributing

Thanks for your interest. Pangeia is small and strictly structured, so
there is little to learn before your first pull request.

Full guide: [CONTRIBUTING.md](https://github.com/Danil0ws/pangeia/blob/main/CONTRIBUTING.md).

## Project rules

- **Code and comments in English**, always — including shell comments,
  commit messages and workflow names.
- **One topic per pull request.** Small diffs get reviewed fast.
- **Never break a supported manager.** If you touch detection or an
  adapter, add or update a test.
- Translations are welcome for any language that already has a README.

## Running the tests

```bash
git clone https://github.com/Danil0ws/pangeia
cd pangeia
bash tests/run.sh
```

No dependencies: plain bash, running on Linux, macOS and in GitHub Actions.

## Where things live

| Path | Responsibility |
|---|---|
| `src/domain/` | Pure decisions: detection and name mapping |
| `src/adapters/` | One file per manager, four functions each |
| `src/application/` | Use cases orchestrating domain and adapters |
| `src/cli.sh` | Arguments and user-facing output |
| `bin/pangeia` | Entry point wiring the layers together |
| `shell/pangeia.sh` | Shell integration sourced from `.bashrc`/`.zshrc` |
| `tests/` | The test suite and its tiny harness |

## Adding a package manager

1. Create `src/adapters/<name>.sh`.
2. Implement `pangeia_adapter_install`, `pangeia_adapter_remove`,
   `pangeia_adapter_search` and `pangeia_adapter_update`. Use `pangeia_run`
   so dry-run mode and privilege escalation keep working.
3. Return the id from `pangeia_detect_manager` in `src/domain/detect.sh`,
   **in the right order** (immutable systems first).
4. Add cases to `tests/test_adapters.sh` and `tests/test_detect.sh`.

## Commits and releases

Pangeia uses [Conventional Commits](https://www.conventionalcommits.org/)
(`feat:`, `fix:`, `docs:`, `chore:`). The version and `CHANGELOG.md` are
generated automatically from those messages on `main`, and a release is
published on every version bump — nobody edits the version by hand.

## License

Contributions are released under the MIT license — see
[LICENSE](https://github.com/Danil0ws/pangeia/blob/main/LICENSE).
