# Pangeia

**Um comando para instalar qualquer pacote em qualquer Linux.**

Pangeia detecta o gerenciador de pacotes do sistema e usa o comando certo
para cada distribuição. Você escreve `pkg install git` e ele roda o
comando correto no Debian, Arch, Fedora, Alpine, openSUSE, NixOS e outros.

!!! tip "Instalação em uma linha"

    ```bash
    curl -fsSL https://raw.githubusercontent.com/Danil0ws/pangeia/main/install.sh | bash
    ```

## Por que existe

Cada distribuição tem o seu gerenciador e a sua sintaxe. Quem usa várias
máquinas — ou escreve tutoriais e scripts — acaba mantendo uma tabela
mental de comandos. O Pangeia reduz isso a uma palavra:

| Ação | Debian | Arch | Alpine | Nix |
|---|---|---|---|---|
| Instalar | `apt-get install -y` | `pacman -S --needed` | `apk add` | `nix-env -iA` |
| Remover | `apt-get remove -y` | `pacman -Rns` | `apk del` | `nix-env -e` |
| Atualizar | `apt-get update` | `pacman -Syu` | `apk upgrade` | `nix-channel --update` |

Com Pangeia, todas as linhas viram `pkg install git`, `pkg remove git`,
`pkg update`.

## O que está incluído

- Detecção automática de 11 gerenciadores, incluindo sistemas imutáveis.
- Tradução de nomes de pacotes que diferem entre distribuições.
- Fallback para Flatpak quando o pacote não existe no gerenciador nativo.
- Integração com `bash` e `zsh` pelo comando `pkg`.
- Testes sem dependências e integração contínua em Linux e macOS.

## Próximos passos

- [Instalação](installation.md)
- [Uso](usage.md)
- [Contribuindo](contributing.md)
