" scriptencoding utf-8

let g:plug_shallow = 1
let g:plug_pwindow = 'vertical leftbelow new'

call plug#begin(g:vim_plug_dir)

Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'preservim/nerdcommenter'
Plug 'markonm/traces.vim'
Plug 'luochen1990/rainbow'
Plug 'junegunn/vim-easy-align'
Plug 'machakann/vim-highlightedyank'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'mileszs/ack.vim'
Plug 'rhysd/clever-f.vim'
Plug 'vim-scripts/a.vim'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf'
Plug 'NoahTheDuke/vim-just'

if (v:version > 704)
    Plug 'Yggdroot/indentLine'
    Plug 'karb94/vim-smoothie'
endif

if (v:version > 801)
    Plug 'APZelos/blamer.nvim'
endif

if executable('ctags')
    Plug 'preservim/tagbar'
    let is_tagbar_loaded = 1
endif

let g:mdot_lsp_plug = get(g:, 'mdot_lsp_plug', 'ale')

" if g:mdot_lsp_plug ==# 'coc'
"     let coc_dir = $HOME . '/.config/coc'
"     if isdirectory(coc_dir) && v:version > 801
"         Plug 'neoclide/coc.nvim', { 'branch': 'release' }
"         let t:is_coc_loaded = 1
"         let g:coc_disable_startup_warning = 1
"     endif
" elseif g:mdot_lsp_plug ==# 'ale'
"     Plug 'w0rp/ale'
" endif

call plug#end()

if exists('g:stop_load_user2') && g:stop_load_user2 == 1
    finish
endif

" ====== airline ====== [[[1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_splits = 1

let g:airline#extensions#tabline#show_buffers = 1

let g:airline#extensions#tabline#alt_sep = 1
let g:airline#extensions#tabline#left_sep = ' '

let g:airline_disable_statusline = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#overflow_marker = '…'

let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#buffer_nr_format = '%s:'
" ====== airline ]]]1

" ====== blamer.nvim ====== [[[1
" let g:blamer_enabled = 1
let g:blamer_delay = 800
let g:blamer_date_format = '%y/%m/%d %H:%M'

" highlight Blamer guifg=lightgrey
" ====== blamer.nvim]]]1

" ====== nerdcommenter ======
let g:NERDSpaceDelims = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" nnoremap <silent> <leader>/ <Plug>NERDCommenterInvert " vim8.2 cannot work?
nnoremap <silent> <leader>/ :call nerdcommenter#Comment('n', "Invert")<CR>
vnoremap <silent> <leader>/ :call nerdcommenter#Comment('n', "Invert")<CR>

" ====== nerdtree vim-nerdtree-tabs
let g:NERDTreeShowHidden = 1
let g:NERDTreeShowIcons = 0

let g:NERDTreeWinSize = min([24, winwidth(0) / 5])
let g:NERDTreeWinSizeMax = 40
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'

let g:nerdtree_tabs_autoclose = 1
let g:nerdtree_tabs_open_on_console_startup = 2

nnoremap <C-n> :NERDTreeTabsToggle<CR>
" Find file in tree, and cursor move to the file position in tree
nnoremap <leader>m :NERDTreeFind<CR>

" ====== rainbow
let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle

" ====== vim-highlightedyank
let g:highlightedyank_highlight_duration = 700

" ====== vim-oscyank
" nnoremap <leader>c :call OSCYankOperator<CR>
" nnoremap <leader>cc <leader>c_
" vnoremap <leader>c <Plug>OSCYankVisual

" ====== tagbar
if exists('is_tagbar_loaded') > 0
    let g:tagbar_width = max([30, winwidth(0) / 5])
    let g:tagbar_compact = 2
    let g:tagbar_indent = 1
    let g:tagbar_iconchars = ['+', '-']
    let g:tagbar_sort = 0
    let g:tagbar_position = 'topleft vertical'
    nnoremap <silent> gi :TagbarToggle<CR>

    let t:mstl_tagbar = '%8*%{tagbar#currenttag("[%s] ","")}%{tagbar#currenttagtype("(%s) ", "")}%*'
    call SetStatusLineMiddlePart(t:mstl_tagbar, 1)
endif

" ====== indentLine ======
let g:indentLine_char_list = [ '⎸' ]
let g:indentLine_conceallevel = 2
let g:vim_json_conceal = 0
let g:indentLine_defaultGroup = 'SpecialKey'
let g:indentLine_color_term = 241

" ====== easyalign ======
" Start interactive EasyAlign in visual mode (e.g. vipga)
xnoremap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nnoremap ga <Plug>(EasyAlign)


" ====== fzf ====== [[[1
" NOTE: must add this path, otherwise fzf cannot work
let &runtimepath .= ',' . g:vim_plug_dir . '/fzf/bin'

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '40%' }

augroup vimrcFzf
    autocmd!
    autocmd FileType fzf set laststatus=0 noshowmode noruler
        \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup END

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.cache/fzf-history'


" [Buffers] 如果可能跳到已存在窗口
let g:fzf_buffers_jump = 0
" [[B]Commits] 自定义被'git log'使用的选项
" let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" [Tags] 定义用来产生tag的命令
let g:fzf_tags_command = 'ctags --c++-kinds=+px --fields=+aiKSz --extras=+q --links=no --exclude={.git/,.github/,build/} -R '
" [Commands] --expect expression for directly executing the command
let g:fzf_commands_expect = 'alt-enter,ctrl-x'

nnoremap <leader>f :FZF<CR>
" ====== fzf ====== ]]]1

" following settings must load coc


" vim:fdm=marker:fmr=[[[,]]]
