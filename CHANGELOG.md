# Changelog

All notable changes to this project are documented in this file. The format
follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this
project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Entries below the first release are generated automatically from
[Conventional Commits](https://www.conventionalcommits.org/) by
release-please. Do not edit generated sections by hand.

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
- Dependency-free test suite with an isolated `PATH` for detection and a
  dry-run mode for the adapters.
- GitHub Actions for continuous integration (Linux + macOS matrix,
  ShellCheck, shfmt), automatic releases and a multi-language
  documentation site on GitHub Pages.

[0.1.0]: https://github.com/Danil0ws/pangeia/releases/tag/v0.1.0
