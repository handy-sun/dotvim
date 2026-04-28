# dotvim — 个人 Vim 配置

一套精心打磨的 Vim/Neovim 配置，面向 C/C++ 开发，通过 [vim-plug](https://github.com/junegunn/vim-plug) 管理插件，提供丰富的类 IDE 功能。

## 文件结构

```
dotvim/
├── init.vim          # 主配置：选项、函数、键位映射、自动命令、插件引导（550 行）
├── user2.vim         # 插件声明与插件专属配置（204 行）
├── .virc             # 最小化备用 Vim 配置（9 行）
├── vimrc -> init.vim # 软链接，供 Vim 自动发现
└── .gitignore        # 忽略 after/、autoload/、plugged/
```

### 各文件职责

- **init.vim** — 入口文件。设定 `g:first_vimrc_dir`，缺失时自动安装 vim-plug，然后 source `user2.vim`。包含所有核心配置、自定义函数、键位映射、自动命令和自定义状态栏。
- **user2.vim** — 由 init.vim source。包含 `plug#begin/end` 块及所有插件声明，外加每个插件的配置段。受 `g:stop_load_user2` 守卫保护（vim-plug 缺失时跳过）。
- **.virc** — 最小化配置（autoread、number、无 backup/swapfile），用于精简模式或兜底。

## 架构决策

### 插件管理器
- 使用 **vim-plug** 并支持自动安装：若 `plug.vim` 不存在，init.vim 会自动下载并在 VimEnter 时触发 `PlugInstall`。
- 插件目录：`g:vim_data_dir/plugged`（`g:vim_data_dir` 在 Neovim 下为 `stdpath('data')/site`，原生 Vim 下为 vimrc 所在目录）。
- `g:plug_shallow = 1`，使用浅克隆。

### 状态栏
- 纯手工打造，不依赖插件。状态栏由 `g:mdot_left_stl` + `g:mdot_mstl_list`（6 槽位数组）+ `g:mdot_right_stl` 拼接而成。
- 插件通过 `SetStatusLineMiddlePart(str, idx)` 向中间状态栏注册自己的段——tagbar 使用了槽位 1。
- User1–User9 颜色组在 `s:ColorsDefault()` 中定义，深色主题。

### Vim/Neovim 兼容
- 通过 `has('nvim')` 分支处理缓存目录路径（`~/.cache/nvim` vs `~/.cache/vim`）。
- `termencoding` 守卫：Neovim 无此选项。
- 持久化撤销、交换文件、备份目录统一放在 `t:cacheVim` 下。

### 插件体系

| 类别 | 插件 |
|---|---|
| 界面 | vim-airline、indentLine、traces.vim |
| 导航 | nerdtree、vim-nerdtree-tabs、fzf、a.vim、clever-f.vim |
| 编辑 | nerdcommenter、vim-easy-align、auto-pairs（已注释） |
| 版本控制 | vim-fugitive、vim-gitgutter、blamer.nvim |
| 搜索 | ack.vim、fzf |
| 语法 | vim-cpp-enhanced-highlight、rainbow |
| LSP | ale/coc（均已注释）、vim-sleuth |
| 代码导航 | tagbar（依赖 ctags）、vim-smoothie |

### 代码折叠约定
- 使用 `fdm=marker`，折叠标记为 `[[[` 和 `]]]`，配合嵌套数字（如 `[[[1`、`]]]1`）。
- init.vim 和 user2.vim 中的各段可按类别折叠。

## 键位映射参考

Leader：`<space>`

### 核心操作
| 按键 | 功能 |
|---|---|
| `<leader>w` | 保存文件（`:w`） |
| `<leader>q` | 退出（`:q`） |
| `<leader>Q` | 强制退出（`:q!`） |
| `<leader><bs>` | 全部保存并退出（`:wqa`） |
| `sd` | 删除当前缓冲区 |
| `<C-a>` | 全选（`ggVG`） |

### 窗口与缓冲区导航
| 按键 | 功能 |
|---|---|
| `<leader><Left>` / `<leader><Right>` | 上一个/下一个缓冲区 |
| `<leader>[` / `<leader>]` | 垂直分割窗口收窄/加宽 |
| `<leader>j` / `<leader>k` | 水平分割窗口缩短/增高 |
| `tn/tk/tj/to/tc` | 新建/下一个/上一个/仅保留/关闭标签页 |
| `zl` | 列出缓冲区并提示切换 |

### 搜索与替换
| 按键 | 功能 |
|---|---|
| `sa` | 用上次复制的寄存器替换整个文件 |
| `sr` | 用光标下单词替换整个文件 |
| `s/` | 用上次搜索模式替换整个文件 |
| `<Esc>` | 清除搜索高亮并重绘 |
| `n`/`N` | 始终向后/向前跳转（与默认相反，配合增量搜索习惯） |

### 文本操作
| 按键 | 功能 |
|---|---|
| `<S-Up>` / `<S-Down>` | 上移/下移当前行 |
| `<leader><Up>` / `<leader><Down>` | 向上/向下复制当前行 |
| `sc` / `sv` | 复制/粘贴 inner word |
| `sw` / `so` | 复制/粘贴 inner WORD |
| `<leader>"` | 用双引号包裹单词 |
| `<leader>;` | 行尾追加分号 |
| `<leader>W` | 清除行尾空格 |
| `<leader><CR>` | 下方插入空行 |

### 分割窗口与标签页
| 按键 | 功能 |
|---|---|
| `sh`/`sl` | 在当前目录左/右方向垂直分割 |
| `sk`/`sj` | 在当前目录上/下方向水平分割 |
| `se` | 在当前目录编辑文件 |
| `st` | 在当前目录新建标签页 |

### 插入模式
| 按键 | 功能 |
|---|---|
| `<C-d>` | 删除当前行 |
| `<C-z>` | 撤销 |
| `<C-u>` | 删除至行首 |
| `<C-k>` | 删除至行尾 |

### 标签与定义跳转
| 按键 | 功能 |
|---|---|
| `gD` | 在右侧分割窗口跳转到定义 |
| `gi` | 切换 tagbar |

### FZF
| 按键 | 功能 |
|---|---|
| `<leader>f` | 打开 FZF |
| `<leader>m` | 在 NERDTree 中定位当前文件 |

## 开发工作流

1. **编辑**：直接修改 `init.vim` 或 `user2.vim`。
2. **测试**：source 当前文件（`:source %`）或重新加载全部（`<leader>fr` → 调用 `SourceAllVimRc()`）。
3. **提交**：在仓库内执行 `git add -p` + `git commit`，使用 Conventional Commits 规范。

### 自动重载行为
- `vimrcEx` 自动命令组在 `BufWritePost` 且 `autoread` 开启时自动 source 修改过的 `*vimrc`/`*.vim` 文件。
- `<leader>fr` 命令会 source `/etc/`、`$HOME` 下的 vimrc 文件，并清除搜索高亮。

## 平台与依赖

- **目标**：Vim 8.1+，兼容 Neovim
- **操作系统**：macOS（部分条件逻辑中用到 `hostname()` 检查）
- **外部依赖**：`ctags`（tagbar 需要）、`rg`/ripgrep（`:grep` 首选）、`xclip`（可视模式下系统剪贴板）
- **Shell**：VimEnter 时配置 `shellredir`

## 约定

- 临时/缓存变量使用 `t:` 前缀，全局插件风格变量使用 `g:m_dot_`。
- 搜索：`ignorecase` + `smartcase`——默认忽略大小写，含大写时区分。
- 缩进：tabstop=4、shiftwidth=4、smartindent+cindent。例外：YAML（sw=2、expandtab）、Lua（noexpandtab、ts=4）。
- 折叠：默认 manual，`foldlevelstart=99`（所有折叠展开）。
- `gdefault` 开启——替换命令默认带 `/g`，键位映射中无需显式加 `/g`。
