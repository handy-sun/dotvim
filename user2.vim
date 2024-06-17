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
" Plug 'ycm-core/YouCompleteMe'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'w0rp/ale'

if (v:version >= 802)
    Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
    Plug 'Yggdroot/indentLine'
    Plug 'karb94/vim-smoothie'
endif

if executable('ctags')
    Plug 'preservim/tagbar'
    let is_tagbar_loaded = 1
endif

let coc_dir = $HOME.'/.config/coc'
if isdirectory(coc_dir) && exists('g:mdot_load_coc')
    Plug 'neoclide/coc.nvim', { 'branch': 'release' }
    let is_coc_loaded = 1
endif

call plug#end()


" ====== airline ====== [[[1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_splits = 1

let g:airline#extensions#tabline#show_buffers = 1

let g:airline#extensions#tabline#alt_sep = 1
let g:airline#extensions#tabline#left_sep = ' '

let g:airline_disable_statusline = 1
" only show file name
let g:airline#extensions#tabline#formatter = 'unique_tail'
" how to show if overlength
let g:airline#extensions#tabline#overflow_marker = '…'

let g:airline#extensions#tabline#buffer_idx_mode = 1
nnoremap <leader>1 <Plug>AirlineSelectTab1
nnoremap <leader>2 <Plug>AirlineSelectTab2
nnoremap <leader>3 <Plug>AirlineSelectTab3
nnoremap <leader>4 <Plug>AirlineSelectTab4
nnoremap <leader>5 <Plug>AirlineSelectTab5
nnoremap <leader>6 <Plug>AirlineSelectTab6
nnoremap <leader>7 <Plug>AirlineSelectTab7
nnoremap <leader>8 <Plug>AirlineSelectTab8
nnoremap <leader>9 <Plug>AirlineSelectTab9
nnoremap <leader>0 <Plug>AirlineSelectTab0
nnoremap <leader>- <Plug>AirlineSelectPrevTab
nnoremap <leader>= <Plug>AirlineSelectNextTab
" ====== airline ]]]1


" ====== nerdcommenter ======
let g:NERDSpaceDelims = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" nnoremap <silent> <leader>/ <Plug>NERDCommenterInvert " vim8.2 cannot work?
nnoremap <leader>/ :call nerdcommenter#Comment('n', "Invert")<CR>

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
nnoremap <leader>c :call OSCYankOperator<CR>
nnoremap <leader>cc <leader>c_
vmap <leader>c <Plug>OSCYankVisual

" ====== tagbar
if exists('is_tagbar_loaded') > 0
    let g:tagbar_width = max([30, winwidth(0) / 5])
    let g:tagbar_compact = 2
    let g:tagbar_indent = 1
    let g:tagbar_iconchars = ['+', '-']
    let g:tagbar_sort = 0
    nnoremap <silent> <F2> :TagbarToggle<CR>
endif

" ====== indentLine ======
let g:indentLine_char_list = ['┃', '|', '¦']
let g:indentLine_conceallevel = 0


" ====== easyalign ======
" Start interactive EasyAlign in visual mode (e.g. vipga)
xnoremap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nnoremap ga <Plug>(EasyAlign)


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


" following settings must load coc
if ! exists('is_coc_loaded')
  finish
endif

" ====== coc.nvim ====== [[[1
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

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
nnoremap <silent> [g <Plug>(coc-diagnostic-prev)
nnoremap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)

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

" coc custom
augroup clangdEx
    au FileType javascript setlocal omnifunc=coc#refresh()
    au FileType cpp setlocal omnifunc=coc#refresh()
    au FileType c,cpp nnoremap <leader>h :ClangdSwitchSourceHeaderVSplit<CR>
augroup END
" ====== coc.nvim ]]]1

" vim:fdm=marker:fmr=[[[,]]]
