scriptencoding utf-8

let user_vim_dir = $HOME.(has('win32') ? '\vimfiles' : '/.vim')

let g:plug_shallow = 1
" let g:plug_window  = 'enew'
" let g:plug_window = 'vertical topright new'
let g:plug_pwindow = 'vertical leftbelow new'
" let g:plug_pwindow =above 12new'
" let g:plug_url_format = 'git@github.com:%s.git'

call plug#begin(user_vim_dir.'/plugged')

Plug 'preservim/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'preservim/nerdcommenter'
Plug 'markonm/traces.vim'
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
Plug 'luochen1990/rainbow'
" Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug'] }
Plug 'junegunn/vim-easy-align'
Plug 'machakann/vim-highlightedyank'
Plug 'ojroques/vim-oscyank', { 'branch': 'main' }
Plug 'karb94/vim-smoothie'
Plug 'tpope/vim-sleuth'
Plug 'majutsushi/tagbar'
Plug 'skywind3000/vim-terminal-help'

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

" -------- markdown
" map <F3> :MarkdownPreview<CR>
" let g:mkdp_auto_start = 0 " Open file auto popup
" let g:mkdp_auto_close = 1
" let g:mkdp_refresh_slow = 1 " Slowly preview, exit 'insert mode' will refresh
" let g:mkdp_open_to_the_world = 1 " Open public network link
" "let g:mkdp_browser = '' " Specific web browser, default follow system browser
" let g:mkdp_echo_preview_url = 1 " Echo link at cmd line
" let g:mkdp_open_ip = '0.0.0.0'
" let g:mkdp_port = '12870'
" let g:mkdp_page_title = '「${name}」' " Default tile is file name

" -------- vim-oscyank
nmap <leader>c :call OSCYankOperator<CR>
nmap <leader>cc <leader>c_
vmap <leader>c <Plug>OSCYankVisual

" ------- tagbar
let g:tagbar_width=30
nnoremap <silent> <F4> :TagbarToggle<CR>

if ! exists('is_ins_coc')
  finish
endif

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
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
" nnoremap <silent> K :call ShowDocumentation()<CR>

" function! ShowDocumentation()
"   if CocAction('hasProvider', 'hover')
"     call CocActionAsync('doHover')
"   else
"     call feedkeys('K', 'in')
"   endif
" endfunction

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

" augroup mygroup
"   autocmd!
"   " Highlight the symbol and its references when holding the cursor
"   autocmd CursorHold * silent call CocActionAsync('highlight')
"   " Setup formatexpr specified filetype(s)
"   autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
"   " Update signature help on jump placeholder
"   autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
" augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
" xmap if <Plug>(coc-funcobj-i)
" omap if <Plug>(coc-funcobj-i)
" xmap af <Plug>(coc-funcobj-a)
" omap af <Plug>(coc-funcobj-a)
" xmap ic <Plug>(coc-classobj-i)
" omap ic <Plug>(coc-classobj-i)
" xmap ac <Plug>(coc-classobj-a)
" omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
" command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
" command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
" command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics
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

