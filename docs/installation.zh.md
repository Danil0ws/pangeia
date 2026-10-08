# 安装

## 一行脚本（推荐）

```bash
curl -fsSL https://raw.githubusercontent.com/Danil0ws/pangeia/main/install.sh | bash
```

没有 `curl`？用 `wget -qO- <同一 URL> | bash`。

它会做三件事：

1. 把 Pangeia 下载到 `~/.local/share/pangeia`（或 `$XDG_DATA_HOME`）。
2. 创建 `~/.local/bin/pangeia` 链接。
3. 把 shell 集成写入 `~/.bashrc` 与 `~/.zshrc`，重复运行也不会写入两次。

打开新终端并测试：

```bash
pkg detect
pkg install git
```

!!! note "PATH"

    如果 `~/.local/bin` 不在 `PATH` 中，安装脚本会提示。
    请在 shell 配置中加入 `export PATH="$HOME/.local/bin:$PATH"`。

## 从源码安装

```bash
git clone https://github.com/Danil0ws/pangeia
cd pangeia
./install.sh
```

或者不安装，直接在克隆目录中运行：

```bash
./bin/pangeia install git
```

## 手动配置 shell

如果你想自己控制：

```bash
# bash
echo '[ -f "$HOME/.local/share/pangeia/shell/pangeia.sh" ] && . "$HOME/.local/share/pangeia/shell/pangeia.sh"' >> ~/.bashrc

# zsh
echo '[ -f "$HOME/.local/share/pangeia/shell/pangeia.sh" ] && . "$HOME/.local/share/pangeia/shell/pangeia.sh"' >> ~/.zshrc
```

这会定义 `pkg` 函数以及葡萄牙语别名（`instalar`、`remover`、`buscar`、
`atualizar`）。

## 卸载

```bash
rm -rf ~/.local/share/pangeia ~/.local/bin/pangeia
# 然后从 ~/.bashrc 与 ~/.zshrc 中删除 "# Pangeia" 那一行
```

## 依赖

需要 `bash`，以及 `git`、`curl`、`wget` 三者之一。运行时没有依赖：
Pangeia 是纯 shell 实现。

既没有 `curl` 也没有 `git`？有两种办法，无需额外下载：

- 用发行版自带的包管理器安装其中之一：
  `apt-get install curl`、`dnf install curl`、`apk add curl`；
- 或者把本仓库复制到目标机器上（U 盘、`scp`），在目录中运行
  `./install.sh`——本地检出会就地安装，不再下载。
