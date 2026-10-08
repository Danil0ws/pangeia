<div align="center">

<img src="docs/assets/logo.png" alt="Pangeia" width="150">

# Pangeia

**一条命令，在任意 Linux 发行版上安装任意软件包。**

[Português](README.pt-BR.md) · [English](README.md) · [Русский](README.ru.md)

[![CI](https://github.com/Danil0ws/pangeia/actions/workflows/ci.yml/badge.svg)](https://github.com/Danil0ws/pangeia/actions/workflows/ci.yml)
[![Docs](https://img.shields.io/badge/docs-danil0ws.github.io-blue)](https://danil0ws.github.io/pangeia/)
[![License: MIT](https://img.shields.io/badge/license-MIT-green)](LICENSE)

</div>

Pangeia 会检测你系统上的包管理器并使用正确的命令。你输入
`pkg install git`，在 Debian 上它执行 `apt-get install -y git`，在 Arch 上
执行 `pacman -S --needed git`，在 Alpine 上执行 `apk add git`，依此类推——
无需记忆任何细节。

## 支持的包管理器

| 管理器 | 发行版 |
|---|---|
| `apt` | Debian、Ubuntu、Mint、Pop!\_OS、Zorin |
| `dnf` / `yum` | Fedora、RHEL、CentOS、Rocky、Alma |
| `pacman` | Arch、Manjaro、EndeavourOS、Garuda |
| `zypper` | openSUSE Leap 与 Tumbleweed |
| `apk` | Alpine |
| `xbps` | Void Linux |
| `emerge` | Gentoo |
| `rpm-ostree` | Fedora Silverblue、Kinoite、Bazzite |
| `transactional-update` | openSUSE MicroOS、Aeon、Kalpa |
| `nix` | NixOS 与 Nix 用户 |
| `brew` | Homebrew（Linux 与 macOS） |

如果原生管理器中没有该软件包，Pangeia 会在放弃之前尝试 **Flatpak**。

## 安装

```bash
curl -fsSL https://raw.githubusercontent.com/Danil0ws/pangeia/main/install.sh | bash
```

安装脚本会把 Pangeia 下载到 `~/.local/share/pangeia`，在
`~/.local/bin/pangeia` 创建链接，并把 shell 集成写入 `~/.bashrc` 与
`~/.zshrc`。打开新的终端即可：

```bash
pkg install git curl vim
```

想要手动克隆？`git clone https://github.com/Danil0ws/pangeia && cd pangeia && ./install.sh`

## 用法

```bash
pkg install git curl      # 安装
pkg remove firefox        # 卸载
pkg search ripgrep        # 搜索
pkg update                # 更新系统
pkg detect                # 显示检测到的管理器
pkg version               # 显示版本
```

环境变量：

| 变量 | 作用 |
|---|---|
| `PANGEIA_MANAGER` | 强制指定管理器，跳过自动检测 |
| `PANGEIA_DRY_RUN=1` | 只打印命令，不执行 |
| `PANGEIA_OSTREE_MARKER` | 不可变系统标记路径（测试用） |

## 软件包名称

某些软件包在不同发行版中名称不同。Pangeia 会转换已知的差异
（`python-pip`、`apache`、`openssh`、`build-tools`），其余名称原样传递。
新增映射请编辑 `src/domain/mapping.sh`。

## 架构

清晰的架构，四层，每层只负责一件事：

```
src/domain/       纯决策（检测、名称映射）
src/adapters/     每个包管理器一个文件
src/application/  用例（install、remove、search、update）
src/cli.sh        表现层（参数、帮助、输出）
```

核心层不接触 shell 命令，适配层不接触命令行界面。详见 [docs/](docs/)
与[在线文档](https://danil0ws.github.io/pangeia/)。

## 测试

```bash
bash tests/run.sh
```

无需依赖，纯 bash。检测通过隔离 `PATH` 中的桩命令测试，适配器通过
`PANGEIA_DRY_RUN=1` 测试。

## 贡献

请阅读 [CONTRIBUTING.md](CONTRIBUTING.md)。简述：fork、开分支、代码与注释
使用英文、`bash tests/run.sh` 通过，然后提交 pull request。整个项目采用
MIT 许可——见 [LICENSE](LICENSE)。

## 许可证

MIT © Danilo Rodrigues
