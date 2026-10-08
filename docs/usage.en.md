# Usage

## Commands

```bash
pkg install git curl vim     # install one or more packages
pkg remove firefox           # remove
pkg search ripgrep           # search the repositories
pkg update                   # update the system / all packages
pkg detect                   # print the detected manager
pkg version                  # print the version
pkg help                     # help
```

Every command has an alias. `install` is also `i` and `add`; `remove` is also
`rm`, `del` and `uninstall`; `search` is also `find` and `s`; `update` is also
`upgrade` and `up`.

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
