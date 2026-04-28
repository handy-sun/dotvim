# dotvim — Personal Vim Configuration

A carefully curated Vim/Neovim configuration designed for C/C++ development with rich IDE-like features via plugins managed by [vim-plug](https://github.com/junegunn/vim-plug).

## File Structure

```
dotvim/
├── init.vim          # Main config: options, functions, keymaps, autocommands, plugin bootstrap (550 lines)
├── user2.vim         # Plugin declarations + plugin-specific settings (204 lines)
├── .virc             # Minimal fallback Vim settings (9 lines)
├── vimrc -> init.vim # Symlink for Vim discovery
└── .gitignore        # Ignores after/, autoload/, plugged/
```

### Role of Each File

- **init.vim** — Entry point. Sets `g:first_vimrc_dir`, auto-installs vim-plug if missing, then sources `user2.vim`. Contains all core configuration, custom functions, key mappings, autocommands, and the custom statusline.
- **user2.vim** — Sourced by init.vim. Contains `plug#begin/end` block with all plugin declarations, plus per-plugin configuration sections. Protected by `g:stop_load_user2` guard (set when vim-plug is missing).
- **.virc** — Minimal settings (autoread, number, no backup/swapfile) for lean usage or fallback.

## Architecture Decisions

### Plugin Manager
- Uses **vim-plug** with auto-install: if `plug.vim` is not found, init.vim downloads it and triggers `PlugInstall` on VimEnter.
- Plugin directory: `g:vim_data_dir/plugged` (where `g:vim_data_dir` is `stdpath('data')/site` for Neovim, or the vimrc directory for vanilla Vim).
- `g:plug_shallow = 1` for shallow clones.

### Statusline
- Custom-built, not plugin-driven. Statusline is assembled from `g:mdot_left_stl` + `g:mdot_mstl_list` (a 6-slot array) + `g:mdot_right_stl`.
- Plugins register their middle-statusline segments via `SetStatusLineMiddlePart(str, idx)` — tagbar uses this (slot 1).
- Color groups User1–User9 defined in `s:ColorsDefault()` with dark theme.

### Vim/Neovim Compatibility
- Branches on `has('nvim')` for cache directory paths (`~/.cache/nvim` vs `~/.cache/vim`).
- `termencoding` guard: Neovim doesn't have it.
- Persistent undo, swap, and backup dirs all under `t:cacheVim`.

### Plugin Ecosystem

| Category | Plugins |
|---|---|
| UI | vim-airline, indentLine, traces.vim |
| Navigation | nerdtree, vim-nerdtree-tabs, fzf, a.vim, clever-f.vim |
| Editing | nerdcommenter, vim-easy-align, auto-pairs (commented out) |
| Version Control | vim-fugitive, vim-gitgutter, blamer.nvim |
| Search | ack.vim, fzf |
| Syntax | vim-cpp-enhanced-highlight, rainbow |
| LSP | ale/coc (both commented out), vim-sleuth |
| Code Navigation | tagbar (conditional on ctags), vim-smoothie |

### Code Folding Conventions
- Uses `fdm=marker` with fold markers `[[[` and `]]]` plus nesting digits (e.g., `[[[1`, `]]]1`).
- Sections in init.vim and user2.vim are foldable by category.

## Key Mappings Reference

Leader: `<space>`

### Core Operations
| Key | Action |
|---|---|
| `<leader>w` | Save file (`:w`) |
| `<leader>q` | Quit (`:q`) |
| `<leader>Q` | Force quit (`:q!`) |
| `<leader><bs>` | Save all and quit (`:wqa`) |
| `sd` | Delete current buffer |
| `<C-a>` | Select all (`ggVG`) |

### Window & Buffer Navigation
| Key | Action |
|---|---|
| `<leader><Left>` / `<leader><Right>` | Previous/next buffer |
| `<leader>[` / `<leader>]` | Resize vertical split narrower/wider |
| `<leader>j` / `<leader>k` | Resize horizontal split shorter/taller |
| `tn/tk/tj/to/tc` | Tab new/next/previous/only/close |
| `zl` | List buffers and prompt for switch |

### Search & Replace
| Key | Action |
|---|---|
| `sa` | Substitute last yanked register across entire file |
| `sr` | Substitute word under cursor across entire file |
| `s/` | Substitute last search pattern across entire file |
| `<Esc>` | Clear search highlight + redraw |
| `n`/`N` | Always backward/forward (reversed from default for incremental consistency) |

### Text Manipulation
| Key | Action |
|---|---|
| `<S-Up>` / `<S-Down>` | Move line(s) up/down |
| `<leader><Up>` / `<leader><Down>` | Duplicate line above/below |
| `sc` / `sv` | Yank/paste inner word |
| `sw` / `so` | Yank/paste inner WORD |
| `<leader>"` | Wrap word in double quotes |
| `<leader>;` | Append semicolon at EOL |
| `<leader>W` | Trim trailing whitespace |
| `<leader><CR>` | Insert blank line below and stay |

### Splits & Tabs
| Key | Action |
|---|---|
| `sh`/`sl` | Vertical split left/right in current dir |
| `sk`/`sj` | Horizontal split above/below in current dir |
| `se` | Edit file in current dir |
| `st` | Tab new in current dir |

### Insert Mode
| Key | Action |
|---|---|
| `<C-d>` | Delete current line |
| `<C-z>` | Undo |
| `<C-u>` | Delete to start of line |
| `<C-k>` | Delete to end of line |

### Tag & Definition
| Key | Action |
|---|---|
| `gD` | Go to definition in right split |
| `gi` | Toggle tagbar |

### FZF
| Key | Action |
|---|---|
| `<leader>f` | Open FZF |
| `<leader>m` | Find current file in NERDTree |

## Development Workflow

1. **Edit**: Modify `init.vim` or `user2.vim` directly.
2. **Test**: Source the file (`:source %`) or reload all (`<leader>fr` → calls `SourceAllVimRc()`).
3. **Commit**: `git add -p` + `git commit` from within the repo. Conventional commits used.

### Autoreload Behavior
- `vimrcEx` autocmd group sources changed `*vimrc`/`*.vim` files on `BufWritePost` if `autoread` is set.
- `<leader>fr` command sources vimrc files from `/etc/`, `$HOME`, and clears search highlight.

## Platform & Dependencies

- **Target**: Vim 8.1+, Neovim compatible
- **OS**: macOS (hostname check in `hostname()` used in some conditional logic)
- **External deps**: `ctags` (for tagbar), `rg`/ripgrep (preferred for `:grep`), `xclip` (for system clipboard in visual mode)
- **Shell**: Configures `shellredir` on VimEnter

## Conventions

- Use `t:` prefix for transient/cache variables, `g:m_dot_` for global plugin-style vars.
- Search: `ignorecase` + `smartcase` — case-insensitive unless uppercase present.
- Indent: tabstop=4, shiftwidth=4, smartindent+h2:cindent. Exceptions: YAML (sw=2, expandtab), Lua (noexpandtab, ts=4).
- Folding: manual by default, `foldlevelstart=99` (all folds open).
- `gdefault` is on — substitute commands have `/g` by default, so explicit `/g` is not needed in keymaps.
