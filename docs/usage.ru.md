# Использование

## Команды

```bash
pkg install git curl vim     # установить один или несколько пакетов
pkg remove firefox           # удалить
pkg search ripgrep           # искать в репозиториях
pkg update                   # обновить систему / все пакеты
pkg list                     # список установленных пакетов
pkg info ripgrep             # сведения о пакете
pkg clean                    # удалить ненужные пакеты и кэш
pkg explain install ripgrep  # показать родную команду, ничего не выполняя
pkg detect                   # показать определённый менеджер
pkg version                  # версия определённого менеджера (rpm-ostree --version)
pkg -v                       # версия самого Pangeia
pkg help                     # справка
```

Команды — стандартные слова, а под ними у каждого менеджера своя запись.
Вводите вы одно и то же: `remove` — это `apt-get remove -y` в Debian,
`uninstall` в rpm-ostree и `del` в Alpine.

| Команда | Также принимает |
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

`pkg explain <команда>` печатает родную команду для вашей системы и ничего не
выполняет — то же самое, что `PANGEIA_DRY_RUN=1`. Любая команда выполняет под
собой команду менеджера, включая `version`: `pkg version` — это
`rpm-ostree --version` в Silverblue и `apt-get --version` в Debian, а версия
самого Pangeia — это `pkg --version`. Команда без сопоставления печатает эту
справку, а не пытается угадать.

Интеграция с оболочкой также добавляет португальские псевдонимы:

```bash
instalar git      # pkg install git
remover git       # pkg remove git
buscar git        # pkg search git
atualizar         # pkg update
```

## Переменные окружения

| Переменная | Действие |
|---|---|
| `PANGEIA_MANAGER` | Задать менеджер: `PANGEIA_MANAGER=apt pkg install git` |
| `PANGEIA_DRY_RUN=1` | Печатать команды, не выполняя их |
| `PANGEIA_OSTREE_MARKER` | Путь к маркеру неизменяемой системы (для тестов) |
| `PANGEIA_DIR` | Каталог установки, используемый `install.sh` |

## Имена пакетов

Pangeia переводит имена, которые различаются между дистрибутивами:
`python-pip` становится `python3-pip` в Debian и Fedora, `python-pip` в
Arch и `py3-pip` в Alpine. `apache` становится `apache2` или `httpd` в
зависимости от дистрибутива. Неизвестные имена передаются без изменений.

Полная таблица находится в `src/domain/mapping.sh`.

## Неизменяемые системы

В Fedora Silverblue/Kinoite/Bazzite `rpm-ostree` применяет изменения только
после перезагрузки; в openSUSE MicroOS `transactional-update` ведёт себя так
же. Pangeia сообщает об этом. Для приложений используйте Flatpak, для
инструментов разработки — `toolbox` или `distrobox`.

## Откат к Flatpak

Если родной менеджер не находит пакет, Pangeia пробует
`flatpak install -y --user flathub <имя>`. Поскольку идентификаторы Flatpak
редко совпадают с именами пакетов дистрибутивов, это помогает только для
приложений, опубликованных под тем же именем.

## Примеры

```bash
pkg install git curl wget              # базовые инструменты
pkg install python-pip                 # имя переводится под дистрибутив
pkg install build-tools                # build-essential / base-devel / build-base
pkg remove firefox
pkg update
PANGEIA_DRY_RUN=1 pkg install htop     # только показать, что будет выполнено
```
