# Changelog

All notable changes to this project are documented in this file. The format
follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this
project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Entries below the first release are generated automatically from
[Conventional Commits](https://www.conventionalcommits.org/) by
release-please. Do not edit generated sections by hand.

## [Unreleased]

### Added

- `pangeia list`, `pangeia info` and `pangeia clean` (aliases `ls`/`installed`,
  `show`/`describe`, `cleanup`/`autoremove`), the three remaining commands
  every supported manager has. Each adapter gained `pangeia_adapter_list`,
  `pangeia_adapter_info` and `pangeia_adapter_clean`, so the same word is
  `dpkg-query -W` / `rpm-ostree status` / `pacman -Q` / `brew list` underneath.
- `pangeia explain` covers them too: `pangeia explain clean` prints the
  manager's housekeeping commands without running them.

### Changed

- `pangeia version` asks the **manager**, not Pangeia: it runs
  `rpm-ostree --version` on Silverblue, `apt-get --version` on Debian,
  `pacman -V` on Arch, and so on through a new `pangeia_adapter_version` in
  every adapter. Pangeia's own version moved to `pangeia -v` / `--version`.
- A command with no mapping prints the help and exits 1, instead of an error
  with a "did you mean" suggestion; the edit-distance suggester it needed is
  gone.

### Fixed

- The installer created `~/.bashrc`/`~/.zshrc` only when they already
  existed, so a shell whose rc file was missing got no integration and no
  warning. It now creates the rc of the shell in use (`$SHELL`) and, for
  bash/zsh, tells you how to load it in the shell you have open
  (`source ~/.bashrc`) — the reason `pkg: command not found` appeared right
  after a successful install. A shell that reads neither file (fish, say)
  gets the line to paste instead of silence.
- Re-running the installer now reports the integration it finds instead of
  skipping it silently.

### Added

- **Command vocabulary** (`src/domain/commands.sh`): one canonical name per
  intent and every accepted spelling mapped onto it (`install`/`i`/`add`/`get`,
  `remove`/`rm`/`del`/`delete`/`uninstall`/`erase`,
  `search`/`find`/`s`/`lookup`, `update`/`upgrade`/`up`/`refresh`), so the same
  word works on every manager.
- **`pangeia explain <command>`** (alias `dry-run`): prints the native command
  for the detected manager without running it — `pangeia explain remove
  firefox` shows `apt-get remove -y firefox` on Debian and
  `rpm-ostree uninstall firefox` on Silverblue.
- A mistyped command is reported with a suggestion (`pangeia verison` →
  `did you mean 'version'?`) instead of being passed to the manager.

### Fixed

- `search` now honours `PANGEIA_DRY_RUN=1` (and `pangeia explain`) like the
  other actions, through the new read-only helper `pangeia_query`, which never
  escalates privileges.

## [0.1.0] - 2026-10-07

### Added

- Automatic detection of the system package manager: apt, dnf/yum, pacman,
  zypper, apk, xbps, emerge, rpm-ostree, transactional-update, nix and brew.
- Adapter architecture where each package manager implements install,
  remove, search and update behind a single interface.
- Command-line interface with the aliases `install`/`i`/`add`,
  `remove`/`rm`/`del`, `search`/`find`, `update`/`upgrade`/`up`, plus
  `detect`, `version` and `help`.
- Shell integration (`pkg`, `pangeia` and the Portuguese aliases) sourced
  from `.bashrc` or `.zshrc`, working in bash and zsh.
- Package-name mapping for the cases that differ across distributions
  (`python-pip`, `apache`, `openssh`, `build-tools`).
- Flatpak fallback when a package is not found in the native manager.
- One-line installer (`curl ... | bash`) that installs into
  `~/.local/share/pangeia`, links `~/.local/bin/pangeia` and wires the
  shell integration idempotently.
- Installer fallbacks: `wget` when `curl` is missing, and in-place
  installation from a local checkout when the machine has no network tool
  at all.
- Dependency-free test suite with an isolated `PATH` for detection and a
  dry-run mode for the adapters.
- Project logo (`docs/assets/logo.png`) used by the READMEs and by the
  documentation theme.
- GitHub Actions for continuous integration (Linux + macOS matrix,
  ShellCheck, shfmt), automatic releases and a multi-language
  documentation site on GitHub Pages.

[0.1.0]: https://github.com/Danil0ws/pangeia/releases/tag/v0.1.0
