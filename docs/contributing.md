# Contribuindo

Obrigado pelo interesse. O Pangeia é pequeno e tem uma estrutura rígida,
então há pouco para aprender antes do primeiro pull request.

Guia completo: [CONTRIBUTING.md](https://github.com/Danil0ws/pangeia/blob/main/CONTRIBUTING.md).

## Regras do projeto

- **Código e comentários em inglês**, sempre — inclusive comentários de
  shell, mensagens de commit e nomes de workflows.
- **Um assunto por pull request.** Diffs pequenos são revisados rápido.
- **Nunca quebre um gerenciador suportado.** Se mexer na detecção ou em um
  adaptador, adicione ou atualize um teste.
- Traduções são bem-vindas para qualquer idioma que já tenha um README.

## Como rodar os testes

```bash
git clone https://github.com/Danil0ws/pangeia
cd pangeia
bash tests/run.sh
```

Sem dependências: é bash puro e roda em Linux, macOS e no GitHub Actions.

## Onde fica cada coisa

| Caminho | Responsabilidade |
|---|---|
| `src/domain/` | Decisões puras: detecção, tradução de nomes e vocabulário de comandos |
| `src/adapters/` | Um arquivo por gerenciador, nove funções cada |
| `src/application/` | Casos de uso que orquestram domínio e adaptadores |
| `src/cli.sh` | Argumentos e saída para o usuário |
| `bin/pangeia` | Ponto de entrada que liga as camadas |
| `shell/pangeia.sh` | Integração de shell carregada pelo `.bashrc`/`.zshrc` |
| `tests/` | A suíte de testes e o seu mini harness |

## Adicionar um gerenciador de pacotes

1. Crie `src/adapters/<nome>.sh`.
2. Implemente `pangeia_adapter_install`, `pangeia_adapter_remove`,
   `pangeia_adapter_search` e `pangeia_adapter_update`. Use `pangeia_run`
   para manter o modo dry-run e a escalação de privilégio funcionando.
3. Retorne o id em `pangeia_detect_manager`, em `src/domain/detect.sh`,
   **na ordem correta** (sistemas imutáveis primeiro).
4. Adicione casos em `tests/test_adapters.sh` e `tests/test_detect.sh`.

## Commits e releases

O Pangeia usa [Conventional Commits](https://www.conventionalcommits.org/)
(`feat:`, `fix:`, `docs:`, `chore:`). A versão e o `CHANGELOG.md` são gerados
automaticamente a partir dessas mensagens na branch `main`, e um release é
publicado a cada mudança de versão — ninguém edita a versão à mão.

## Licença

As contribuições são liberadas sob a licença MIT — veja
[LICENSE](https://github.com/Danil0ws/pangeia/blob/main/LICENSE).
