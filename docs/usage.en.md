# Usage

## Commands

```bash
pkg install git curl vim     # install one or more packages
pkg remove firefox           # remove
pkg search ripgrep           # search the repositories
pkg update                   # update the system / all packages
pkg list                     # list installed packages
pkg info ripgrep             # show details for a package
pkg clean                    # remove unused packages and cached files
pkg explain install ripgrep  # print the native command, run nothing
pkg detect                   # print the detected manager
pkg version                  # version of the detected manager (rpm-ostree --version)
pkg --help                   # the manager's help (-h too)
pkg help                     # Pangeia's own help (it shows Pangeia's version)
```

The commands are standard words; underneath, every manager spells them its own
way. You keep typing the same one: `remove` is `apt-get remove -y` on Debian,
`uninstall` on rpm-ostree and `del` on Alpine.

| Command | Also accepts |
|---|---|
| `install` | `i`, `add`, `get` |
| `remove` | `rm`, `del`, `delete`, `uninstall`, `erase` |
| `search` | `find`, `s`, `lookup` |
| `update` | `upgrade`, `up`, `refresh` |
| `list` | `ls`, `installed` |
| `info` | `show`, `describe` |
| `clean` | `cleanup`, `autoremove` |
| `explain` | `dry-run` |
| `detect` | `which` |

`pkg explain <command>` prints the native command for this system without
running anything — the same thing as `PANGEIA_DRY_RUN=1`, with a better name.
Every command runs the manager's own underneath, `version` included:
`pkg version` is `rpm-ostree --version` on Silverblue and `apt-get --version`
on Debian, and the same goes for the flags every manager shares — `pkg
--version`, `pkg -v`, `pkg --help`, `pkg -h`. Pangeia's own version is printed
by `pkg help`. A command with no mapping prints that help instead of
guessing.

The shell integration also ships Portuguese aliases:

```bash
instalar git      # pkg install git
remover git       # pkg remove git
buscar git        # pkg search git
atualizar         # pkg update
```

## Environment variables

| Variable | Effect |
|---|---|
| `PANGEIA_MANAGER` | Force a manager instead of auto-detecting: `PANGEIA_MANAGER=apt pkg install git` |
| `PANGEIA_DRY_RUN=1` | Print the commands instead of running them |
| `PANGEIA_OSTREE_MARKER` | Immutable-system marker path (used by the tests) |
| `PANGEIA_DIR` | Install destination, used by `install.sh` |

## Package names

Pangeia translates the names that change between distributions:
`python-pip` becomes `python3-pip` on Debian and Fedora, `python-pip` on
Arch and `py3-pip` on Alpine. `apache` becomes `apache2` or `httpd`
depending on the distribution. Unknown names pass through unchanged.

The full table lives in `src/domain/mapping.sh`.

## Immutable systems

On Fedora Silverblue/Kinoite/Bazzite, `rpm-ostree` only applies changes
after a reboot; on openSUSE MicroOS `transactional-update` behaves the same
way. Pangeia tells you when that is the case. For applications use Flatpak;
for development tooling use `toolbox` or `distrobox`.

## Flatpak fallback

If the native manager cannot find the package, Pangeia tries
`flatpak install -y --user flathub <name>`. Since Flatpak IDs rarely match
distribution package names, this only helps for applications published
under the same name.

## Examples

```bash
pkg install git curl wget              # basic tooling
pkg install python-pip                 # name translated per distribution
pkg install build-tools                # build-essential / base-devel / build-base
pkg remove firefox
pkg update
PANGEIA_DRY_RUN=1 pkg install htop     # just show the command it would run
```
