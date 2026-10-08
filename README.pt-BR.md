<div align="center">

<img src="docs/assets/logo.png" alt="Pangeia" width="150">

# Pangeia

**Um comando para instalar qualquer pacote em qualquer Linux.**

[English](README.md) · [简体中文](README.zh-CN.md) · [Русский](README.ru.md)

[![CI](https://github.com/Danil0ws/pangeia/actions/workflows/ci.yml/badge.svg)](https://github.com/Danil0ws/pangeia/actions/workflows/ci.yml)
[![Docs](https://img.shields.io/badge/docs-danil0ws.github.io-blue)](https://danil0ws.github.io/pangeia/)
[![License: MIT](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Wiki](https://img.shields.io/badge/wiki-community-blue)](https://github.com/Danil0ws/pangeia/wiki)

</div>

Pangeia detecta o gerenciador de pacotes do seu sistema e usa o comando
certo. Você escreve `pkg install git` e ele roda `apt-get install -y git`
no Debian, `pacman -S --needed git` no Arch, `apk add git` no Alpine, e
assim por diante — sem decorar nada.

## Gerenciadores suportados

| Gerenciador | Distribuições |
|---|---|
| `apt` | Debian, Ubuntu, Mint, Pop!\_OS, Zorin |
| `dnf` / `yum` | Fedora, RHEL, CentOS, Rocky, Alma |
| `pacman` | Arch, Manjaro, EndeavourOS, Garuda |
| `zypper` | openSUSE Leap e Tumbleweed |
| `apk` | Alpine |
| `xbps` | Void Linux |
| `emerge` | Gentoo |
| `rpm-ostree` | Fedora Silverblue, Kinoite, Bazzite |
| `transactional-update` | openSUSE MicroOS, Aeon, Kalpa |
| `nix` | NixOS e usuários do Nix |
| `brew` | Homebrew (Linux e macOS) |

Se o pacote não existir no gerenciador nativo, o Pangeia tenta o
**Flatpak** antes de desistir.

## Instalação

```bash
curl -fsSL https://raw.githubusercontent.com/Danil0ws/pangeia/main/install.sh | bash
```

O instalador baixa o Pangeia para `~/.local/share/pangeia`, cria o atalho
em `~/.local/bin/pangeia` e adiciona a integração de shell no `~/.bashrc`
e no `~/.zshrc`. Abra um shell novo e pronto:

```bash
pkg install git curl vim
```

Prefere clonar? `git clone https://github.com/Danil0ws/pangeia && cd pangeia && ./install.sh`

Sem `curl`? `wget -qO- https://raw.githubusercontent.com/Danil0ws/pangeia/main/install.sh | bash`.

Sem `curl` e sem `git`? Instale um deles pelo gerenciador da sua distro
(`apt-get install curl`, `apk add curl`...), ou copie este repositório para a
máquina e rode `./install.sh` de dentro dele: um checkout local é instalado no
lugar, sem download nenhum.

## Uso

```bash
pkg install git curl      # instala (também: pangeia install / instalar)
pkg remove firefox        # remove (remover)
pkg search ripgrep        # busca (buscar)
pkg update                # atualiza o sistema (atualizar)
pkg explain install htop  # mostra o comando nativo, sem executar
pkg detect                # mostra o gerenciador detectado
pkg version               # versão
```

Os comandos são palavras padrão com sinônimos (`get`, `erase`, `lookup`, `rm`,
`up`...) e cada um é traduzido para a sintaxe do gerenciador por baixo —
`remove` é `apt-get remove -y` no Debian, `uninstall` no rpm-ostree e `del` no
Alpine. `pkg explain <comando>` mostra o que rodaria nesta máquina, e um
comando digitado errado recebe uma sugestão em vez de rodar outra coisa. O
vocabulário todo vive em `src/domain/commands.sh`.

Variáveis de ambiente:

| Variável | Efeito |
|---|---|
| `PANGEIA_MANAGER` | Força um gerenciador em vez de detectar |
| `PANGEIA_DRY_RUN=1` | Só imprime os comandos, não executa |
| `PANGEIA_OSTREE_MARKER` | Caminho do marcador de sistema imutável (testes) |

## Nomes de pacotes

Alguns pacotes têm nomes diferentes em cada distribuição. O Pangeia
traduz os casos conhecidos (`python-pip`, `apache`, `openssh`,
`build-tools`). Qualquer outro nome passa direto. Para adicionar um novo,
edite `src/domain/mapping.sh`.

## Arquitetura

Arquitetura limpa, quatro camadas, cada uma com uma responsabilidade:

```
src/domain/       decisões puras (detecção, tradução de nomes, comandos)
src/adapters/     um arquivo por gerenciador de pacotes
src/application/  casos de uso (install, remove, search, update)
src/cli.sh        apresentação (argv, ajuda, saída)
```

O núcleo não conhece comandos de shell; os adaptadores não conhecem a
interface de linha de comando. Detalhes em [docs/](docs/) e na
[documentação publicada](https://danil0ws.github.io/pangeia/).

## Testes

```bash
bash tests/run.sh
```

Sem dependências: é bash puro. A detecção é testada com comandos falsos
em um `PATH` isolado, e os adaptadores com `PANGEIA_DRY_RUN=1`.

## Contribuindo

Leia o [CONTRIBUTING.md](CONTRIBUTING.md). Resumo: *fork*, branch,
código e comentários em inglês, `bash tests/run.sh` verde, e um pull
request. Todo o projeto é MIT — veja [LICENSE](LICENSE).

## Licença

MIT © Danilo Rodrigues
