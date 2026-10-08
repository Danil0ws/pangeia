# Instalação

## Script de uma linha (recomendado)

```bash
curl -fsSL https://raw.githubusercontent.com/Danil0ws/pangeia/main/install.sh | bash
```

O que ele faz:

1. Baixa o Pangeia para `~/.local/share/pangeia` (ou `$XDG_DATA_HOME`).
2. Cria o link `~/.local/bin/pangeia`.
3. Adiciona a integração de shell ao `~/.bashrc` e ao `~/.zshrc`,
   sem duplicar a linha se você rodar de novo.

Abra um shell novo e teste:

```bash
pkg detect
pkg install git
```

!!! note "PATH"

    Se `~/.local/bin` não estiver no seu `PATH`, o instalador avisa. Adicione
    `export PATH="$HOME/.local/bin:$PATH"` ao seu arquivo de shell.

## A partir do código

```bash
git clone https://github.com/Danil0ws/pangeia
cd pangeia
./install.sh
```

Ou, sem instalar nada, rode direto do clone:

```bash
./bin/pangeia install git
```

## Integração de shell manual

Se preferir controlar você mesmo:

```bash
# bash
echo '[ -f "$HOME/.local/share/pangeia/shell/pangeia.sh" ] && . "$HOME/.local/share/pangeia/shell/pangeia.sh"' >> ~/.bashrc

# zsh
echo '[ -f "$HOME/.local/share/pangeia/shell/pangeia.sh" ] && . "$HOME/.local/share/pangeia/shell/pangeia.sh"' >> ~/.zshrc
```

Isso cria a função `pkg` e os aliases em português (`instalar`, `remover`,
`buscar`, `atualizar`).

## Desinstalação

```bash
rm -rf ~/.local/share/pangeia ~/.local/bin/pangeia
# depois remova a linha "# Pangeia" do ~/.bashrc e do ~/.zshrc
```

## Requisitos

Nenhum além de `bash`, `git` ou `curl`. Não há dependências de tempo de
execução: o Pangeia é shell puro.
