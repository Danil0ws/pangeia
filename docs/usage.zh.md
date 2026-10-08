# 用法

## 命令

```bash
pkg install git curl vim     # 安装一个或多个软件包
pkg remove firefox           # 卸载
pkg search ripgrep           # 在仓库中搜索
pkg update                   # 更新系统 / 全部软件包
pkg explain install ripgrep  # 只显示原生命令，不执行
pkg detect                   # 显示检测到的管理器
pkg version                  # 显示版本
pkg help                     # 帮助
```

命令是统一的叫法，底层则由各个管理器自行实现。无论用哪种系统，你输入的
都是同一个词：`remove` 在 Debian 上是 `apt-get remove -y`，在 rpm-ostree 上
是 `uninstall`，在 Alpine 上是 `del`。

| 命令 | 也可以写作 |
|---|---|
| `install` | `i`、`add`、`get` |
| `remove` | `rm`、`del`、`delete`、`uninstall`、`erase` |
| `search` | `find`、`s`、`lookup` |
| `update` | `upgrade`、`up`、`refresh` |
| `explain` | `dry-run` |
| `detect` | `which` |

`pkg explain <命令>` 只打印本机将执行的原生命令，不执行任何操作——等同于
`PANGEIA_DRY_RUN=1`。命令写错时会给出提示（`pkg verison` →
*did you mean 'version'?*），而不是猜测后执行。

shell 集成还提供葡萄牙语别名：

```bash
instalar git      # pkg install git
remover git       # pkg remove git
buscar git        # pkg search git
atualizar         # pkg update
```

## 环境变量

| 变量 | 作用 |
|---|---|
| `PANGEIA_MANAGER` | 强制指定管理器：`PANGEIA_MANAGER=apt pkg install git` |
| `PANGEIA_DRY_RUN=1` | 只打印命令，不执行 |
| `PANGEIA_OSTREE_MARKER` | 不可变系统标记路径（测试用） |
| `PANGEIA_DIR` | `install.sh` 使用的安装目录 |

## 软件包名称

Pangeia 会自动转换在不同发行版中名称不同的软件包：`python-pip` 在 Debian
和 Fedora 上变成 `python3-pip`，在 Arch 上是 `python-pip`，在 Alpine 上是
`py3-pip`。`apache` 根据发行版变成 `apache2` 或 `httpd`。未知名称原样传递。

完整对照表位于 `src/domain/mapping.sh`。

## 不可变系统

在 Fedora Silverblue/Kinoite/Bazzite 上，`rpm-ostree` 只在重启后才应用更改；
openSUSE MicroOS 的 `transactional-update` 也是如此。Pangeia 会在这种情况下
给出提示。应用程序请使用 Flatpak，开发工具建议使用 `toolbox` 或 `distrobox`。

## Flatpak 回退

如果原生管理器找不到该软件包，Pangeia 会尝试
`flatpak install -y --user flathub <名称>`。由于 Flatpak ID 很少与发行版的
软件包名称一致，这通常只对同名发布的应用有效。

## 示例

```bash
pkg install git curl wget              # 基础工具
pkg install python-pip                 # 名称按发行版转换
pkg install build-tools                # build-essential / base-devel / build-base
pkg remove firefox
pkg update
PANGEIA_DRY_RUN=1 pkg install htop     # 只显示将会执行的命令
```
