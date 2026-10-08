# Pangeia

**一条命令，在任意 Linux 发行版上安装任意软件包。**

Pangeia 会检测系统的包管理器，并为每个发行版使用正确的命令。你输入
`pkg install git`，它会在 Debian、Arch、Fedora、Alpine、openSUSE、NixOS
等系统上执行对应的正确命令。

!!! tip "一行安装"

    ```bash
    curl -fsSL https://raw.githubusercontent.com/Danil0ws/pangeia/main/install.sh | bash
    ```

## 为什么需要它

每个发行版都有自己的包管理器和语法。经常使用多台机器、或编写教程和脚本
的人，往往要在脑子里维护一张命令对照表。Pangeia 把它简化成一个词：

| 操作 | Debian | Arch | Alpine | Nix |
|---|---|---|---|---|
| 安装 | `apt-get install -y` | `pacman -S --needed` | `apk add` | `nix-env -iA` |
| 卸载 | `apt-get remove -y` | `pacman -Rns` | `apk del` | `nix-env -e` |
| 更新 | `apt-get update` | `pacman -Syu` | `apk upgrade` | `nix-channel --update` |

有了 Pangeia，这些命令都变成 `pkg install git`、`pkg remove git` 和
`pkg update`。

## 包含内容

- 自动检测 11 种包管理器，包括不可变系统。
- 转换在不同发行版中名称不同的软件包。
- 当原生管理器缺少该软件包时回退到 Flatpak。
- 通过 `pkg` 命令集成 `bash` 与 `zsh`。
- 无依赖测试，并在 Linux 与 macOS 上持续集成。

## 下一步

- [安装](installation.md)
- [用法](usage.md)
- [贡献](contributing.md)
