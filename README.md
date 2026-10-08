<div align="center">

<img src="docs/assets/logo.png" alt="Pangeia" width="150">

# Pangeia

**One command to install any package on any Linux distribution.**

[Português](README.pt-BR.md) · [简体中文](README.zh-CN.md) · [Русский](README.ru.md)

[![CI](https://github.com/Danil0ws/pangeia/actions/workflows/ci.yml/badge.svg)](https://github.com/Danil0ws/pangeia/actions/workflows/ci.yml)
[![Docs](https://img.shields.io/badge/docs-danil0ws.github.io-blue)](https://danil0ws.github.io/pangeia/)
[![License: MIT](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Wiki](https://img.shields.io/badge/wiki-community-blue)](https://github.com/Danil0ws/pangeia/wiki)

</div>

Pangeia detects your system's package manager and uses the right command.
You type `pkg install git` and it runs `apt-get install -y git` on Debian,
`pacman -S --needed git` on Arch, `apk add git` on Alpine, and so on —
nothing to memorise.

## Supported managers

| Manager | Distributions |
|---|---|
| `apt` | Debian, Ubuntu, Mint, Pop!\_OS, Zorin |
| `dnf` / `yum` | Fedora, RHEL, CentOS, Rocky, Alma |
| `pacman` | Arch, Manjaro, EndeavourOS, Garuda |
| `zypper` | openSUSE Leap and Tumbleweed |
| `apk` | Alpine |
| `xbps` | Void Linux |
| `emerge` | Gentoo |
| `rpm-ostree` | Fedora Silverblue, Kinoite, Bazzite |
| `transactional-update` | openSUSE MicroOS, Aeon, Kalpa |
| `nix` | NixOS and Nix users |
| `brew` | Homebrew (Linux and macOS) |

If a package is missing from the native manager, Pangeia falls back to
**Flatpak** before giving up.

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/Danil0ws/pangeia/main/install.sh | bash
```

The installer fetches Pangeia into `~/.local/share/pangeia`, links the
binary into `~/.local/bin/pangeia` and wires the shell integration into
`~/.bashrc` and `~/.zshrc`. `pkg` is a shell function, so load it in the
shell you already have open (`source ~/.bashrc`) or open a new one, then go:

```bash
pkg install git curl vim
```

Prefer cloning? `git clone https://github.com/Danil0ws/pangeia && cd pangeia && ./install.sh`

No `curl`? `wget -qO- https://raw.githubusercontent.com/Danil0ws/pangeia/main/install.sh | bash`.

No `curl` and no `git`? Install one with your own package manager
(`apt-get install curl`, `apk add curl`, ...), or copy this repository to the
machine and run `./install.sh` from it: a local checkout is installed in
place, with no download at all.

## Usage

```bash
pkg install git curl      # install
pkg remove firefox        # remove
pkg search ripgrep        # search
pkg update                # update the system
pkg explain install htop  # print the native command, run nothing
pkg detect                # print the detected manager
pkg version               # print the version
```

Commands are standard words with synonyms (`get`, `erase`, `lookup`, `rm`,
`up`, ...), and each one maps onto the syntax of the manager underneath —
`remove` is `apt-get remove -y` on Debian, `uninstall` on rpm-ostree, `del` on
Alpine. `pkg explain <command>` prints what would actually run on this machine,
and a mistyped command gets a suggestion instead of running the wrong thing.
The whole vocabulary lives in `src/domain/commands.sh`.

Environment variables:

| Variable | Effect |
|---|---|
| `PANGEIA_MANAGER` | Force a manager instead of auto-detecting |
| `PANGEIA_DRY_RUN=1` | Print the commands instead of running them |
| `PANGEIA_OSTREE_MARKER` | Immutable-system marker path (tests) |

## Package names

Some packages are named differently per distribution. Pangeia translates
the known cases (`python-pip`, `apache`, `openssh`, `build-tools`).
Anything else passes through untouched. To add one, edit
`src/domain/mapping.sh`.

## Architecture

Clean architecture, four layers, one responsibility each:

```
src/domain/       pure decisions (detection, name mapping, commands)
src/adapters/     one file per package manager
src/application/  use cases (install, remove, search, update)
src/cli.sh        presentation (argv, help, output)
```

The core never knows shell commands; the adapters never know the CLI.
Details in [docs/](docs/) and in the
[published documentation](https://danil0ws.github.io/pangeia/).

## Tests

```bash
bash tests/run.sh
```

No dependencies: plain bash. Detection is tested with stub commands in an
isolated `PATH`, and the adapters with `PANGEIA_DRY_RUN=1`.

## Contributing

Read [CONTRIBUTING.md](CONTRIBUTING.md). Short version: fork, branch,
code and comments in English, `bash tests/run.sh` green, then a pull
request. The whole project is MIT — see [LICENSE](LICENSE).

## License

MIT © Danilo Rodrigues
