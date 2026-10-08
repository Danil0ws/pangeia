# Uso

## Comandos

```bash
pkg install git curl vim     # instala um ou mais pacotes
pkg remove firefox           # remove
pkg search ripgrep           # busca nos repositórios
pkg update                   # atualiza o sistema / todos os pacotes
pkg explain install ripgrep  # mostra o comando nativo, sem executar nada
pkg detect                   # mostra o gerenciador detectado
pkg version                  # mostra a versão
pkg help                     # ajuda
```

Os comandos são palavras padrão; por baixo, cada gerenciador tem a sua. Nada
disso muda o que você digita: `remove` é `apt-get remove -y` no Debian,
`uninstall` no rpm-ostree e `del` no Alpine.

| Comando | Também aceita |
|---|---|
| `install` | `i`, `add`, `get` |
| `remove` | `rm`, `del`, `delete`, `uninstall`, `erase` |
| `search` | `find`, `s`, `lookup` |
| `update` | `upgrade`, `up`, `refresh` |
| `explain` | `dry-run` |
| `detect` | `which` |

`pkg explain <comando>` imprime o comando nativo do seu sistema sem executar
nada — é o `PANGEIA_DRY_RUN=1` com um nome melhor. Um comando digitado errado
recebe uma sugestão (`pkg verison` → *did you mean 'version'?*) em vez de ser
adivinhado.

Em português, os aliases de shell são:

```bash
instalar git      # pkg install git
remover git       # pkg remove git
buscar git        # pkg search git
atualizar         # pkg update
```

## Variáveis de ambiente

| Variável | Efeito |
|---|---|
| `PANGEIA_MANAGER` | Força um gerenciador em vez de detectar. `PANGEIA_MANAGER=apt pkg install git` |
| `PANGEIA_DRY_RUN=1` | Imprime os comandos em vez de executá-los |
| `PANGEIA_OSTREE_MARKER` | Caminho do marcador de sistema imutável (usado nos testes) |
| `PANGEIA_DIR` | Destino da instalação, usado pelo `install.sh` |

## Nomes de pacotes

Pangeia traduz automaticamente os nomes que mudam entre distribuições:
`python-pip` vira `python3-pip` no Debian e no Fedora, `python-pip` no Arch
e `py3-pip` no Alpine. `apache` vira `apache2` ou `httpd`, conforme a
distribuição. Nomes desconhecidos passam sem alteração.

A tabela completa está em `src/domain/mapping.sh`.

## Sistemas imutáveis

No Fedora Silverblue/Kinoite/Bazzite o `rpm-ostree` só aplica as mudanças
depois de reiniciar; no openSUSE MicroOS o `transactional-update` funciona
do mesmo jeito. O Pangeia avisa quando esse é o caso. Para aplicativos, use
Flatpak; para ferramentas de desenvolvimento, `toolbox` ou `distrobox`.

## Flatpak como fallback

Se o gerenciador nativo não encontrar o pacote, o Pangeia tenta
`flatpak install -y --user flathub <nome>`. Como os IDs do Flatpak raramente
coincidem com os nomes das distribuições, isso só ajuda em aplicativos
publicados com o mesmo nome.

## Exemplos

```bash
pkg install git curl wget              # ferramentas básicas
pkg install python-pip                 # nome traduzido por distribuição
pkg install build-tools                # build-essential / base-devel / build-base
pkg remove firefox
pkg update
PANGEIA_DRY_RUN=1 pkg install htop     # só mostra o comando que rodaria
```
