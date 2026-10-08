# Установка

## Скрипт одной строкой (рекомендуется)

```bash
curl -fsSL https://raw.githubusercontent.com/Danil0ws/pangeia/main/install.sh | bash
```

Что он делает:

1. Скачивает Pangeia в `~/.local/share/pangeia` (или `$XDG_DATA_HOME`).
2. Создаёт ссылку `~/.local/bin/pangeia`.
3. Добавляет интеграцию с оболочкой в `~/.bashrc` и `~/.zshrc`, не
   дублируя строку при повторном запуске.

Откройте новый терминал и проверьте:

```bash
pkg detect
pkg install git
```

!!! note "PATH"

    Если `~/.local/bin` отсутствует в `PATH`, установщик сообщит об этом.
    Добавьте `export PATH="$HOME/.local/bin:$PATH"` в файл оболочки.

## Из исходников

```bash
git clone https://github.com/Danil0ws/pangeia
cd pangeia
./install.sh
```

Или, ничего не устанавливая, запустите прямо из клона:

```bash
./bin/pangeia install git
```

## Ручная интеграция с оболочкой

Если хотите настроить сами:

```bash
# bash
echo '[ -f "$HOME/.local/share/pangeia/shell/pangeia.sh" ] && . "$HOME/.local/share/pangeia/shell/pangeia.sh"' >> ~/.bashrc

# zsh
echo '[ -f "$HOME/.local/share/pangeia/shell/pangeia.sh" ] && . "$HOME/.local/share/pangeia/shell/pangeia.sh"' >> ~/.zshrc
```

Это определит функцию `pkg` и португальские псевдонимы (`instalar`,
`remover`, `buscar`, `atualizar`).

## Удаление

```bash
rm -rf ~/.local/share/pangeia ~/.local/bin/pangeia
# затем удалите строку "# Pangeia" из ~/.bashrc и ~/.zshrc
```

## Требования

Ничего, кроме `bash` и `git` либо `curl`. Зависимостей во время работы нет:
Pangeia — это чистый shell.
