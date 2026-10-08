<div align="center">

<img src="docs/assets/logo.png" alt="Pangeia" width="150">

# Pangeia

**Одна команда, чтобы установить любой пакет в любом дистрибутиве Linux.**

[Português](README.pt-BR.md) · [English](README.md) · [简体中文](README.zh-CN.md)

[![CI](https://github.com/Danil0ws/pangeia/actions/workflows/ci.yml/badge.svg)](https://github.com/Danil0ws/pangeia/actions/workflows/ci.yml)
[![Docs](https://img.shields.io/badge/docs-danil0ws.github.io-blue)](https://danil0ws.github.io/pangeia/)
[![License: MIT](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Wiki](https://img.shields.io/badge/wiki-community-blue)](https://github.com/Danil0ws/pangeia/wiki)

</div>

Pangeia определяет пакетный менеджер вашей системы и использует нужную
команду. Вы пишете `pkg install git`, и он выполняет
`apt-get install -y git` в Debian, `pacman -S --needed git` в Arch,
`apk add git` в Alpine и так далее — ничего не нужно запоминать.

## Поддерживаемые менеджеры

| Менеджер | Дистрибутивы |
|---|---|
| `apt` | Debian, Ubuntu, Mint, Pop!\_OS, Zorin |
| `dnf` / `yum` | Fedora, RHEL, CentOS, Rocky, Alma |
| `pacman` | Arch, Manjaro, EndeavourOS, Garuda |
| `zypper` | openSUSE Leap и Tumbleweed |
| `apk` | Alpine |
| `xbps` | Void Linux |
| `emerge` | Gentoo |
| `rpm-ostree` | Fedora Silverblue, Kinoite, Bazzite |
| `transactional-update` | openSUSE MicroOS, Aeon, Kalpa |
| `nix` | NixOS и пользователи Nix |
| `brew` | Homebrew (Linux и macOS) |

Если пакета нет в родном менеджере, Pangeia пробует **Flatpak**, прежде
чем сдаться.

## Установка

```bash
curl -fsSL https://raw.githubusercontent.com/Danil0ws/pangeia/main/install.sh | bash
```

Установщик скачивает Pangeia в `~/.local/share/pangeia`, создаёт ссылку
`~/.local/bin/pangeia` и прописывает интеграцию с оболочкой в
`~/.bashrc` и `~/.zshrc`. Откройте новый терминал и работайте:

```bash
pkg install git curl vim
```

Хотите клонировать? `git clone https://github.com/Danil0ws/pangeia && cd pangeia && ./install.sh`

Нет `curl`? `wget -qO- https://raw.githubusercontent.com/Danil0ws/pangeia/main/install.sh | bash`.

Нет ни `curl`, ни `git`? Поставьте любой из них своим пакетным менеджером
(`apt-get install curl`, `apk add curl`), либо скопируйте этот репозиторий на
машину и запустите `./install.sh` из него: локальная копия ставится на месте,
без скачивания.

## Использование

```bash
pkg install git curl      # установить
pkg remove firefox        # удалить
pkg search ripgrep        # найти
pkg update                # обновить систему
pkg explain install htop  # показать родную команду, ничего не выполняя
pkg detect                # показать определённый менеджер
pkg version               # версия определённого менеджера (rpm-ostree --version)
pkg --version             # версия самого Pangeia
```

Команды — стандартные слова с синонимами (`get`, `erase`, `lookup`, `rm`,
`up`…) и каждая переводится в синтаксис нижележащего менеджера: `remove` —
это `apt-get remove -y` в Debian, `uninstall` в rpm-ostree, `del` в Alpine.
`pkg explain <команда>` покажет, что именно выполнилось бы на этой машине, а
опечатка сопровождается подсказкой. Весь словарь лежит в
`src/domain/commands.sh`.

Переменные окружения:

| Переменная | Действие |
|---|---|
| `PANGEIA_MANAGER` | Задать менеджер вместо автоопределения |
| `PANGEIA_DRY_RUN=1` | Печатать команды, не выполняя их |
| `PANGEIA_OSTREE_MARKER` | Путь к маркеру неизменяемой системы (тесты) |

## Имена пакетов

Некоторые пакеты называются по-разному в разных дистрибутивах. Pangeia
переводит известные случаи (`python-pip`, `apache`, `openssh`,
`build-tools`), остальные имена передаются как есть. Чтобы добавить
новый, отредактируйте `src/domain/mapping.sh`.

## Архитектура

Чистая архитектура, четыре слоя, у каждого одна ответственность:

```
src/domain/       чистые решения (определение, отображение имён)
src/adapters/     по одному файлу на пакетный менеджер
src/application/  сценарии (install, remove, search, update)
src/cli.sh        представление (аргументы, справка, вывод)
```

Ядро не знает команд оболочки, адаптеры не знают интерфейс командной
строки. Подробности в [docs/](docs/) и в
[опубликованной документации](https://danil0ws.github.io/pangeia/).

## Тесты

```bash
bash tests/run.sh
```

Без зависимостей: чистый bash. Определение тестируется командами-заглушками
в изолированном `PATH`, адаптеры — через `PANGEIA_DRY_RUN=1`.

## Участие

Прочитайте [CONTRIBUTING.md](CONTRIBUTING.md). Кратко: форк, ветка,
код и комментарии на английском, зелёный `bash tests/run.sh`, затем pull
request. Весь проект под MIT — см. [LICENSE](LICENSE).

## Лицензия

MIT © Danilo Rodrigues
