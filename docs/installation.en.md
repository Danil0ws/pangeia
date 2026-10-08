# Installation

## One-line script (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/Danil0ws/pangeia/main/install.sh | bash
```

No `curl`? `wget -qO- <same URL> | bash`.

What it does:

1. Downloads Pangeia into `~/.local/share/pangeia` (or `$XDG_DATA_HOME`).
2. Creates the `~/.local/bin/pangeia` link.
3. Adds the shell integration to `~/.bashrc` and `~/.zshrc`, without
   duplicating the line if you run it again.

Open a new shell and try it:

```bash
pkg detect
pkg install git
```

!!! note "PATH"

    If `~/.local/bin` is not on your `PATH`, the installer tells you. Add
    `export PATH="$HOME/.local/bin:$PATH"` to your shell file.

## From source

```bash
git clone https://github.com/Danil0ws/pangeia
cd pangeia
./install.sh
```

Or, without installing anything, run it straight from the clone:

```bash
./bin/pangeia install git
```

## Manual shell integration

If you would rather wire it yourself:

```bash
# bash
echo '[ -f "$HOME/.local/share/pangeia/shell/pangeia.sh" ] && . "$HOME/.local/share/pangeia/shell/pangeia.sh"' >> ~/.bashrc

# zsh
echo '[ -f "$HOME/.local/share/pangeia/shell/pangeia.sh" ] && . "$HOME/.local/share/pangeia/shell/pangeia.sh"' >> ~/.zshrc
```

This defines the `pkg` function and the Portuguese aliases (`instalar`,
`remover`, `buscar`, `atualizar`).

## Uninstall

```bash
rm -rf ~/.local/share/pangeia ~/.local/bin/pangeia
# then remove the "# Pangeia" line from ~/.bashrc and ~/.zshrc
```

## Requirements

`bash` and one of `git`, `curl` or `wget`. There are no runtime dependencies:
Pangeia is pure shell.

No `curl` and no `git`? Two ways out, without downloading anything new:

- install one of them with the distribution's own manager:
  `apt-get install curl`, `dnf install curl`, `apk add curl`;
- or copy this repository to the machine (USB stick, `scp`) and run
  `./install.sh` inside it — a local checkout is installed in place of the
  download.
