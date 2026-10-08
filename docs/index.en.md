# Pangeia

**One command to install any package on any Linux distribution.**

Pangeia detects the system's package manager and uses the right command for
each distribution. You type `pkg install git` and it runs the correct
command on Debian, Arch, Fedora, Alpine, openSUSE, NixOS and more.

!!! tip "One-line install"

    ```bash
    curl -fsSL https://raw.githubusercontent.com/Danil0ws/pangeia/main/install.sh | bash
    ```

## Why it exists

Every distribution has its own manager and its own syntax. Anyone using
several machines — or writing tutorials and scripts — ends up keeping a
mental table of commands. Pangeia reduces that to one word:

| Action | Debian | Arch | Alpine | Nix |
|---|---|---|---|---|
| Install | `apt-get install -y` | `pacman -S --needed` | `apk add` | `nix-env -iA` |
| Remove | `apt-get remove -y` | `pacman -Rns` | `apk del` | `nix-env -e` |
| Update | `apt-get update` | `pacman -Syu` | `apk upgrade` | `nix-channel --update` |

With Pangeia every one of those lines becomes `pkg install git`,
`pkg remove git` and `pkg update`.

## What is included

- Automatic detection of 11 managers, immutable systems included.
- Translation of package names that differ across distributions.
- Flatpak fallback when a package is missing from the native manager.
- `bash` and `zsh` integration through the `pkg` command.
- Dependency-free tests and continuous integration on Linux and macOS.

## Next steps

- [Installation](installation.md)
- [Usage](usage.md)
- [Contributing](contributing.md)
