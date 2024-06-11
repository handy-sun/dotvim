scriptencoding utf-8

let user_vim_dir = $HOME.(has('win32') ? '\vimfiles' : '/.vim')

let g:plug_shallow = 1
let g:plug_pwindow = 'vertical leftbelow new'

call plug#begin(user_vim_dir.'/plugged')

Plug 'preservim/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'preservim/nerdcommenter'
Plug 'markonm/traces.vim'
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
Plug 'luochen1990/rainbow'
Plug 'junegunn/vim-easy-align'
Plug 'machakann/vim-highlightedyank'
Plug 'ojroques/vim-oscyank', { 'branch': 'main' }
Plug 'karb94/vim-smoothie'
Plug 'tpope/vim-sleuth'
" Plug 'majutsushi/tagbar'
Plug 'preservim/tagbar'
Plug 'Yggdroot/indentLine'
Plug 'skywind3000/vim-terminal-help'
Plug 'rhysd/clever-f.vim'

let coc_dir = $HOME.'/.config/coc'
if isdirectory(coc_dir)
    let is_ins_coc = 1
    Plug 'neoclide/coc.nvim', { 'branch': 'release' }
    Plug 'octol/vim-cpp-enhanced-highlight'
endif

call plug#end()

" ------- nerdcommenter
let g:NERDSpaceDelims = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" nnoremap <silent> <leader>/ <Plug>NERDCommenterInvert " vim8.2 cannot work?
nnoremap <leader>/ :call nerdcommenter#Comment('n', "Invert")<CR>

" ------- nerdtree vim-nerdtree-tabs
let g:NERDTreeShowHidden = 1
let g:NERDTreeShowIcons = 0

let g:nerdtree_tabs_autoclose = 1
let g:nerdtree_tabs_open_on_console_startup = 2

nnoremap <C-n> :NERDTreeTabsToggle<CR>
" Find file in tree, and cursor move to the file position in tree
nnoremap <leader>m :NERDTreeTabsFind<CR>

" -------- rainbow
let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
let g:rainbow_conf = {
\   'guifgs': ['darkorange3', 'seagreen3', 'royalblue3', 'firebrick'],
\   'ctermfgs': ['lightyellow', 'lightcyan','lightblue', 'lightmagenta'],
\   'operators': '_,_',
\   'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\   'separately': {
\       '*': {},
\       'tex': {
\           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
\       },
\       'lisp': {
\           'guifgs': ['darkorange3', 'seagreen3', 'royalblue3', 'firebrick'],
\       },
\       'vim': {
\           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
\       },
\       'html': {
\           'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
\       },
\       'css': 0,
\   }
\}

" ------- vim-highlightedyank
let g:highlightedyank_highlight_duration = 700

" -------- vim-oscyank
nmap <leader>c :call OSCYankOperator<CR>
nmap <leader>cc <leader>c_
vmap <leader>c <Plug>OSCYankVisual

" ------- tagbar
let g:tagbar_width=40
nnoremap <silent> <F8> :TagbarToggle<CR>

if ! exists('is_ins_coc')
  finish
endif

" ------- indentLine
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_conceallevel = 2


" --------- coc.nvim Example Vim configuration
" Use tab for trigger completion with characters ahead and navigate
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

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
if has('autocmd')
augroup clangdEx
  au FileType javascript setlocal omnifunc=coc#refresh()
  au FileType cpp setlocal omnifunc=coc#refresh()
  au FileType c,cpp nnoremap <leader>h :ClangdSwitchSourceHeaderVSplit<CR>
augroup END
endif

