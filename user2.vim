scriptencoding utf-8

let user_vim_dir = $HOME.(has('win32') ? '\vimfiles' : '/.vim')

let g:plug_shallow = 1
let g:plug_pwindow = 'vertical leftbelow new'

call plug#begin(user_vim_dir . '/plugged')

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
" Plug 'jiangmiao/auto-pairs'
" Plug 'joshdick/onedark.vim'
Plug 'junegunn/fzf'

if (v:version > 704)
    Plug 'Yggdroot/indentLine'
    Plug 'karb94/vim-smoothie'
    Plug 'APZelos/blamer.nvim'
endif

if executable('ctags')
    Plug 'preservim/tagbar'
    let is_tagbar_loaded = 1
endif

let g:mdot_lsp_plug = get(g:, 'mdot_lsp_plug', 'coc')

if g:mdot_lsp_plug ==# 'coc'
    let coc_dir = $HOME . '/.config/coc'
    if isdirectory(coc_dir)
        Plug 'neoclide/coc.nvim', { 'branch': 'release' }
        let t:is_coc_loaded = 1
    endif
elseif g:mdot_lsp_plug ==# 'ale'
    Plug 'w0rp/ale'
endif

call plug#end()


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

" ====== onedark ======
" if empty($TMUX)
    " if has('nvim')
        " let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
    " endif
    " if has('termguicolors')
        " set termguicolors
    " endif
" endif

" call CheckAndSwitchColorScheme('onedark')

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
    nnoremap <silent> <F2> :TagbarToggle<CR>

    let t:mstl_tagbar = '%8*%{tagbar#currenttag("[%s] ","")}%{tagbar#currenttagtype("(%s) ", "")}%*'
    call SetStatusLineMiddlePart(t:mstl_tagbar, 1)
endif

" ====== indentLine ======
let g:indentLine_char_list = ['┃']
let g:indentLine_conceallevel = 2
let g:vim_json_conceal = 0
let g:indentLine_defaultGroup = 'SpecialKey'
" let g:indentLine_color_term = 222

" ====== easyalign ======
" Start interactive EasyAlign in visual mode (e.g. vipga)
xnoremap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nnoremap ga <Plug>(EasyAlign)


" ====== fzf ====== [[[1
" NOTE: must add this path, otherwise fzf cannot work
let &runtimepath .= ',' . user_vim_dir . '/plugged/fzf/bin'

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
" let g:fzf_layout = { 'down': '~40%' }
let g:fzf_layout = { 'down': '40%' }

autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

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

if g:mdot_lsp_plug ==# 'ale'
    " ====== ale ====== [[[1
    let g:ale_sign_column_always = 0
    let g:ale_set_highlights = 0

    let g:ale_sign_error = '✗'
    let g:ale_sign_warning = '⚡'
    "在vim自带的状态栏中整合ale，airline也可以显示这些信息
    let g:ale_statusline_format = ['✗ %d', '⚡ %d', '✔ OK']

    let g:ale_echo_msg_error_str = 'E'
    let g:ale_echo_msg_warning_str = 'W'
    let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

    nnoremap asp <Plug>(ale_previous_wrap)
    nnoremap asn <Plug>(ale_next_wrap)

    "文件内容发生变化时不进行检查
    " let g:ale_lint_on_text_changed = 'never'
    "打开文件时不进行检查
    let g:ale_lint_on_enter = 0

    let g:ale_c_gcc_options              = '-Wall -Werror -O2 -std=c11'
    let g:ale_c_clang_options            = '-Wall -Werror -O2 -std=c11'
    let g:ale_c_cppcheck_options         = ''

    let g:ale_cpp_gcc_options            = '-Wall -Werror -O2 -std=c++17'
    let g:ale_cpp_clang_options          = '-Wall -Werror -O2 -std=c++17'
    let g:ale_cpp_cppcheck_options       = ''

    let g:ale_linters = {
                \   'c++': ['clang++'],
                \   'c': ['clang'],
                \   'python' : ['flake8']
                \}
    " ====== ale ]]]1
endif


if ! exists('t:is_coc_loaded')
    inoremap <silent><TAB>   <C-R>=TabMoveInPopup('n')<CR>
    inoremap <silent><S-TAB> <C-R>=TabMoveInPopup('p')<CR>
    inoremap <silent><expr><CR> pumvisible() ? "\<C-y>" : "\<CR>"

    finish
endif

" ====== coc.nvim ====== [[[1
" coc custom
augroup clangdEx
    au FileType javascript setlocal omnifunc=coc#refresh()
    au FileType cpp setlocal omnifunc=coc#refresh()
    au FileType c,cpp nnoremap <F4> :call ClangdSwitchSourceHeaderVSplit()<CR>
augroup END

let t:mstl_coc = '%1*%{coc#status()}%{get(b:, "coc_current_function", "")}%*'
call SetStatusLineMiddlePart(t:mstl_coc, 0)

function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use tab for trigger completion with characters ahead and navigate
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nnoremap <silent> g[ <Plug>(coc-diagnostic-prev)
nnoremap <silent> g] <Plug>(coc-diagnostic-next)

" GoTo code navigation
nnoremap <silent> <leader>gd <Plug>(coc-definition)
nnoremap <silent> <leader>gy <Plug>(coc-type-definition)
nnoremap <silent> <leader>gi <Plug>(coc-implementation)
nnoremap <silent> <leader>gr <Plug>(coc-references)

" Symbol renaming
nnoremap <leader>rn <Plug>(coc-rename)

nnoremap <silent><nowait> \a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> \e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> \c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> \o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> \s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> \j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> \k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> \p  :<C-u>CocListResume<CR>
" ====== coc.nvim ]]]1

" vim:fdm=marker:fmr=[[[,]]]
