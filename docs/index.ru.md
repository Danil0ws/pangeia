# Pangeia

**Одна команда, чтобы установить любой пакет в любом дистрибутиве Linux.**

Pangeia определяет пакетный менеджер системы и использует правильную
команду для каждого дистрибутива. Вы пишете `pkg install git`, и он
выполняет нужную команду в Debian, Arch, Fedora, Alpine, openSUSE, NixOS и
других системах.

!!! tip "Установка одной строкой"

    ```bash
    curl -fsSL https://raw.githubusercontent.com/Danil0ws/pangeia/main/install.sh | bash
    ```

## Зачем это нужно

У каждого дистрибутива свой менеджер и свой синтаксис. Тем, кто работает с
несколькими машинами — или пишет руководства и скрипты — приходится держать
в голове таблицу команд. Pangeia сводит её к одному слову:

| Действие | Debian | Arch | Alpine | Nix |
|---|---|---|---|---|
| Установить | `apt-get install -y` | `pacman -S --needed` | `apk add` | `nix-env -iA` |
| Удалить | `apt-get remove -y` | `pacman -Rns` | `apk del` | `nix-env -e` |
| Обновить | `apt-get update` | `pacman -Syu` | `apk upgrade` | `nix-channel --update` |

С Pangeia все эти строки превращаются в `pkg install git`, `pkg remove git`
и `pkg update`.

## Что входит

- Автоопределение 11 менеджеров, включая неизменяемые системы.
- Перевод имён пакетов, которые различаются между дистрибутивами.
- Откат к Flatpak, если пакета нет в родном менеджере.
- Интеграция с `bash` и `zsh` через команду `pkg`.
- Тесты без зависимостей и непрерывная интеграция на Linux и macOS.

## Дальше

- [Установка](installation.md)
- [Использование](usage.md)
- [Участие](contributing.md)
