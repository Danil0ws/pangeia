# Использование

## Команды

```bash
pkg install git curl vim     # установить один или несколько пакетов
pkg remove firefox           # удалить
pkg search ripgrep           # искать в репозиториях
pkg update                   # обновить систему / все пакеты
pkg detect                   # показать определённый менеджер
pkg version                  # показать версию
pkg help                     # справка
```

У каждой команды есть псевдоним. `install` — это также `i` и `add`;
`remove` — также `rm`, `del`, `uninstall`; `search` — также `find` и `s`;
`update` — также `upgrade` и `up`.

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
