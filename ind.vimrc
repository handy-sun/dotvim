scriptencoding utf-8

" ====== custom function ====== [[[1
function! XTermPasteBegin()
    set pastetoggle=<Esc>[201~
    set paste
    return ''
endfunction

function! s:ColorsDefault() abort
    hi User1 ctermbg=darkgrey ctermfg=red guibg=#414752 guifg=#ec5f66
    hi User2 ctermbg=darkgrey ctermfg=white guibg=#414752 guifg=#d9d9d9
    hi User3 ctermbg=darkgrey ctermfg=magenta guibg=#414752 guifg=#ae8abe
    hi User4 ctermbg=darkgrey ctermfg=cyan guibg=#414752 guifg=#0cb0ae
    hi User5 ctermbg=darkgrey ctermfg=green guibg=#414752 guifg=#358661
    hi User6 ctermbg=darkgrey ctermfg=yellow guibg=#414752 guifg=#d6bf55
    hi User7 ctermbg=darkgrey ctermfg=blue guibg=#414752 guifg=#4f92ec
    hi User8 ctermbg=240 ctermfg=yellow guifg=#cc7832
    hi User9 ctermbg=240 ctermfg=grey guifg=#c14782
    hi StatusLine ctermbg=darkgrey
    hi StatusLineNC term=reverse ctermbg=238
    hi CursorLine   term=NONE cterm=NONE guibg=#404b59
    hi CursorLineNr term=reverse ctermfg=cyan guifg=#20b0ae
    hi VertSplit ctermbg=grey guibg=#6f6e70
    hi Search term=reverse ctermfg=235 ctermbg=180 guifg=#282C34 guibg=#b48232
    hi LineNr term=NONE ctermfg=grey guifg=#5f5e60
endfunction

function! GetAbsFileDir()
    return expand('%:p:h') . '/'
endfunction

function! LastSearchCount() abort
    let l:cnt = searchcount(#{recompute: 1})
    if empty(l:cnt) || l:cnt.total ==# 0
        return ''
    endif
    if l:cnt.incomplete ==# 1 " timed out
        return printf(' {%s} [?/??] ', @/)
    elseif l:cnt.incomplete ==# 2 " max count exceeded
        if l:cnt.total > l:cnt.maxcount
            let l:fmt = l:cnt.current > l:cnt.maxcount ? ' {%s} [>%d/>%d] ' : ' {%s} [%d/>%d] '
            return printf(l:fmt, @/, l:cnt.current, l:cnt.total)
        else
            return printf(' {%s} [?/0] ', @/)
        endif
    endif
    return printf(' {%s} [%d/%d] ', @/, l:cnt.current, l:cnt.total)
endfunction

function! GoToDefRSplit()
    " let cwin = winnr()
    exe "normal! \<C-w>v"
    exe 'wincmd L | vertical resize -6'
    exe 'tag ' . expand('<cword>')
    " exe 'normal zt'
    " exec cwin . 'wincmd w'
    " silent! wincmd H
endfunction

function! TabMoveInPopup(direction)
    let l:colBaseIdx = col('.') - 1
    if ! l:colBaseIdx || getline('.')[l:colBaseIdx - 1] !~ '\k'
        return "\<TAB>"
    elseif 'p' == a:direction
        return "\<C-p>"
    else
        return "\<C-n>"
    endif
endfunction

if !exists('*SourceAllVimRc')
    function! SourceAllVimRc()
        let l:finls = ''
        exe 'wa'
        for file in ['/etc/vimrc', '/etc/vim/vimrc', '$HOME/.vimrc']
            if filereadable(expand(file))
                exe 'source' file
                let l:finls = l:finls.' '.file
            endif
        endfor
        exe 'noh'
        echo 'sourced files:' . l:finls
    endfunction
endif

" length = 6
let g:mdot_mstl_list = [ '', '', '', '', '', '' ]
function! SetStatusLineMiddlePart(str, idx)
    let l:item = get(g:mdot_mstl_list, a:idx, "NONE")
    if l:item ==# "NONE"
        call add(g:mdot_mstl_list, a:str)
    elseif l:item ==# ''
        let g:mdot_mstl_list[a:idx] = a:str
    else
        echohl 'index: ' . a:idx . ' is not empty!'
    endif

    let &statusline  = g:mdot_left_stl
    let &statusline .= join(g:mdot_mstl_list, "%9* ")
    let &statusline .= g:mdot_right_stl
endfunction

function! CheckAndSwitchColorScheme(scheme)
    try
        execute 'silent! colorscheme ' . a:scheme
        return 1
    catch /^Vim\%((\a\+)\)\=:E185/
        return 0
    endtry
endfunction
" ====== custom function ]]]1

" ====== options ====== [[[1
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set termencoding=utf-8

set fileformats=unix,dos,mac

if has('syntax')
    syntax on
endif

if has('multi_byte') && &encoding ==# 'utf-8'
    let t:isMultiByte = 1
else
    let t:isMultiByte = 0
endif

" filetype
filetype on                     " Load plugins according to detected filetype.
filetype plugin on              " Enable filetype plugins
filetype indent on              " load specific type indent file

" base
set nocompatible                " don't bother with vi compatibility
set autoread                    " reload files when changed on disk
set autowrite
set gdefault                    " substitute flag 'g' on
set confirm                     " processing ont save or read-only file, pop confirm
set shortmess=aoOTI
set magic                       " For regular expressions turn magic on
set title                       " change the terminal's title
set history=1000                " history : how many lines of history VIM has to remember
set scrolloff=3                 " movement keep x lines when scrolling
set noerrorbells
set visualbell t_vb=

set timeout           " for mappings
set timeoutlen=1000   " default value
set ttimeout          " for key codes
set ttimeoutlen=10    " unnoticeable small value

" set nobackup                    " do not keep a backup file
set nowritebackup

if has('nvim')
    let t:cacheVim = $HOME . '/.cache/nvim'
else
    let t:cacheVim = $HOME . '/.cache/vim'
endif

let t:undoDir = t:cacheVim . '/undo'
let t:swapDir = t:cacheVim . '/swap'
let t:bakDir = t:cacheVim . '/backup'
let t:vimInfoFile = t:cacheVim . '/viminfo'

" undo dir
if has('persistent_undo')
    let &undodir = t:undoDir
    if !isdirectory(&undodir)
        silent! call mkdir(&undodir, 'p')
    endif
    set undofile
endif

" swap dir
let &directory = t:swapDir
if !isdirectory(&directory)
    silent! call mkdir(&directory, 'p')
endif
set swapfile

" backup dir
let &backupdir = t:bakDir
if !isdirectory(&backupdir)
    silent! call mkdir(&backupdir, 'p')
endif

let &viminfo .= ',!'                    " save global variable
let &viminfo .= ',n' . t:vimInfoFile    " set <viminfo> file path

" --- show
set number                      " show line numbers
set ruler                       " show the current row and column
set showcmd                     " display incomplete commands
set showmode                    " display current modes
set showmatch                   " jump to matches when entering parentheses
set matchtime=1                 " tenths of a second to show the matching parenthesis
set cursorline
set splitright
set splitbelow
set ttyfast                     " Faster redrawing.
set list
set relativenumber
set background=dark

" indent
set autoindent
set cindent
set smartindent
set shiftround

set tabstop=4                   " table key width
set smarttab                    " at the beginning of line and section?

" search
set hlsearch                    " highlight searches
set incsearch                   " do incremental searching, search as you type
set ignorecase                  " !!! ignore case when searching
set smartcase                   " no ignorecase if Uppercase char present
set infercase

" select & complete
set selection=exclusive          " selection donnot contain the last word
set selectmode=mouse,key
if has('mouse')
    set mouse=a                       " use mouse anywher in buffer
endif

set completeopt=longest,menu            " coding complete with filetype check
" set clipboard^=unnamed,unnamedplus
set suffixes+=.a,.1,.class
set wildmenu                            " show a navigable menu for tab completion
set wildmode=longest,list,full
set wildignore=.git,.hg,.svn,__pycache__,*.pyc,*.o,*.out,*.class,*.jpg,*.jpeg,*.png,*.gif,*.zip,*build*,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**
set wildoptions=tagfile
set wildignorecase

if t:isMultiByte
    let &listchars = 'tab:»·,trail:•,extends:→,precedes:←,nbsp:±'
    let &fillchars = 'vert: ,stl: ,stlnc: ,diff: '
    if has('showbreak')
        let &showbreak = '⣿'
    endif
else
    let &listchars = 'tab:>-,trail:.,extends:>,precedes:<,nbsp:+'
    let &fillchars = 'vert: ,stlnc:#'
    if has('showbreak')
        let &showbreak = '->'
    endif
endif

" --- others
set backspace=indent,eol,start  " make that backspace key work the way it should
set whichwrap+=h,l,<,>,[,],~    " allow backspace and cursor crossline border
set report=0                    " commands to tell user which line modified
set diffopt=filler,iwhite,internal,linematch:60,algorithm:patience

if has('folding')
    set foldenable
    set foldlevelstart=99
    set foldmethod=manual
endif

set langmenu=zh_CN.UTF-8
set helplang=en

set formatoptions=croqn2mB1
set sessionoptions=blank,buffers,curdir,folds,help,options,tabpages,winsize,slash,unix,resize

if &term =~ "xterm"
    " SecureCRT versions prior to 6.1.x do not support 4-digit DECSET
    "    let &t_ti = "\<Esc>[?1049h"
    "    let &t_te = "\<Esc>[?1049l"
    " Use 2-digit DECSET instead
    let &t_ti = "\<Esc>[?47h"
    let &t_te = "\<Esc>[?47l"
endif

if empty($TMUX)
    let &t_SI = "\<Esc>]50;CursorShape=1\x7\<Esc>[?2004h"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7\<Esc>[?2004l"
else
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
endif

if executable('rg')
    let &grepformat = '%f:%l:%c:%m'
    let &grepprg = 'rg --hidden --vimgrep --smart-case -- $*'
else
    let &grepprg = 'grep --binary-files=without-match -irn $*'
endif
" ====== options ]]]1


"  ====== color & theme ====== [[[1
set t_Co=256

hi MyTabSpace ctermfg=darkgrey
match MyTabSpace /\t\| /

" if CheckAndSwitchColorScheme('habamax') == 0
    " call CheckAndSwitchColorScheme('peachpuff')
" endif

" set mark column color
hi! link SignColumn   LineNr
hi! link ShowMarksHLl DiffAdd
hi! link ShowMarksHLu DiffChange

" === status line === [[[2
call s:ColorsDefault()

set laststatus=2   " Always show the status line - use 2 lines for the status bar
set cmdheight=1    " cmdline which under status line height, default = 1

let g:mdot_left_stl  = '%1*[%n] %*'
let g:mdot_left_stl .= '%2*%<%.70f %*'
let g:mdot_left_stl .= '%3*%y%m%r%H%W %*%9*'

let g:mdot_right_stl = '%='

try
    call searchcount()
    let g:mdot_right_stl .= '%#WarningMsg#%{v:hlsearch ? LastSearchCount() : ""}%*'
catch /.*/
endtry

let g:mdot_right_stl .= '%4* %{&ff}[%{&fenc!="" ? &fenc : &enc}%{&bomb ? ",BOM" : ""}] %*'
let g:mdot_right_stl .= '%5*sw:%{&sw}%{&et ? "." : "»"}ts:%{&ts} %*'
let g:mdot_right_stl .= '%6*%l/%L,%c%V %*'
let g:mdot_right_stl .= '%7*%p%% %*'
let g:mdot_right_stl .= '%#ErrorMsg#%{&paste ? " paste " : ""}%*'

" first run it to setup stl only
call SetStatusLineMiddlePart('', 0)

" === status line ]]]2
" ====== color & theme ]]]1


" ====== autocmd group vimrcEx ====== [[[1
augroup vimrcEx
    autocmd VimEnter * set shellredir=>
    " --- Open file at the last edit line
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"zvzz" | endif
    " --- Autoreload .vim
    au BufWritePost,FileWritePost *vimrc,*.vim nested if &l:autoread > 0 | source <afile> | echo 'source ' . bufname('%') | endif
    " --- Check if file changed when its window is focus, more eager than 'autoread'
    au FocusGained * checktime
    " --- Always keep user default color in stl
    au ColorScheme * call s:ColorsDefault()
    " au BufWinEnter * normal! zvzz
    " au CursorHold * if pumvisible() == 0 | pclose | endif
    " --- Highlight current line only on focused window
    au WinEnter,BufEnter,InsertLeave * if ! &cursorline && &filetype !~# '^\(dashboard\|clap_\)' && ! &pvw | setlocal cursorline | endif
    au WinLeave,BufLeave,InsertEnter * if &cursorline && &filetype !~# '^\(dashboard\|clap_\)' && ! &pvw | setlocal nocursorline | endif
    " --- These kind of files donnot set undofile
    au BufWritePre /tmp/*,COMMIT_EDITMSG,MERGE_MSG,*.tmp setlocal noundofile
    au BufRead,BufNew tmux*.conf setf tmux
    au BufRead,BufNew *.conf,*.config setf config
    au BufRead,BufNew *.log setf messages
    au FileType yaml set shiftwidth=2 expandtab
    au FileType lua set noexpandtab tabstop=4 softtabstop=0
    au FileType systemd setlocal commentstring=#\ %s
    au FileType crontab setlocal nobackup nowritebackup
    au FileType help if &buftype != 'quickfix' | wincmd L | vertical resize -10 | endif
    " au FileType c,cpp,cmake,java,python,vim,json let g:mdot_load_coc = 1
augroup END
" ====== autocmd group vimrcEx ]]]1


" ====== maps bind ====== [[[1
let mapleader = "\<space>"

" === normal noremap ===
nnoremap <space>s :w<CR>
nnoremap <space>q :wq<CR>
nnoremap <space><bs> :wqa<CR>
nnoremap <space>e :q!<CR>
nnoremap <C-a> ggVG
nnoremap <space><Tab> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

" cancel highlight search word and clean screen
nnoremap <silent> <leader><space> :let @/=''<CR>:diffupdate<CR>:syntax sync fromstart<CR>

" always goto backward search result
nnoremap <expr> n  'Nn'[v:searchforward]
" always goto forward search result
nnoremap <expr> N  'nN'[v:searchforward]

nnoremap g; g;zvzz
nnoremap g, g,zvzz

" Yank text to EOL
nnoremap <silent> Y y$

" range mapping (v:count1)
" move current line [count] up/down
nnoremap <C-Up>   :<C-u>exe 'move -' . (1 + v:count1)<CR>
nnoremap <C-Down> :<C-u>exe 'move +' . v:count1<CR>
" add [count] line(s) above/below the current line
nnoremap [\  :<C-u>put! =repeat(nr2char(10), v:count1)<CR>'[
nnoremap ]\  :<C-u>put  =repeat(nr2char(10), v:count1)<CR>
" add [count] space(s) behind cursor, and cursor move follow the word
nnoremap [<space> :<C-u>exe 'normal! i' . repeat(' ', v:count1)<CR>l
" add [count] space(s) after cursor, and cursor postion donnot change
" TDDO: for range
nnoremap ]<space> my:<C-u>exe 'normal! a '<CR>`y

nnoremap <leader>-  :<C-u>exe v:count1 . 'bprevious'<CR>
nnoremap <leader>=  :<C-u>exe v:count1 . 'bnext'<CR>
nnoremap <silent>z[ :<C-u>exe v:count1 . 'cprevious'<CR>
nnoremap <silent>z] :<C-u>exe v:count1 . 'cnext'<CR>

nnoremap <leader><Up> yyP
nnoremap <leader><Down> yyp

nnoremap zl :ls<CR>:b
nnoremap z; :registers<CR>
nnoremap z' :marks<CR>:<C-u>'

nnoremap tn :tabnew<CR>
nnoremap tk :tabnext<CR>
nnoremap tj :tabprevious<CR>
nnoremap to :tabonly<CR>
nnoremap tc :tabclose<CR>

nnoremap sc "ayiw
nnoremap sv viw"ap
nnoremap sw "byiW
nnoremap so viW"bp
nnoremap s- vg_p

if &gdefault > 0
    nnoremap sa :%s/<C-R>a/
    nnoremap s/ :%s/<C-R>//
    nnoremap sr :%s/\<<C-R><C-W>\>/
else
    nnoremap sa :%s/<C-R>a//g<Left><Left>
    nnoremap s/ :%s/<C-R>///g<Left><Left>
    nnoremap sr :%s/\<<C-R><C-W>\>//g<Left><Left>
endif

nnoremap se :e <C-R>=GetAbsFileDir()<CR>
nnoremap st :tabnew <C-R>=GetAbsFileDir()<CR>
nnoremap sh :setlocal nosplitright<CR>:vsplit <C-R>=GetAbsFileDir()<CR>
nnoremap sl :setlocal splitright<CR>:vsplit <C-R>=GetAbsFileDir()<CR>
nnoremap sk :setlocal nosplitbelow<CR>:split <C-R>=GetAbsFileDir()<CR>
nnoremap sj :setlocal splitbelow<CR>:split <C-R>=GetAbsFileDir()<CR>

nnoremap <leader>g :CpGrep "" <C-R>=GetAbsFileDir()<CR><C-Left><Left><Left>

nnoremap <leader>[ :vertical resize -8<CR>
nnoremap <leader>] :vertical resize +8<CR>
nnoremap <leader>; :resize -2<CR>
nnoremap <leader>' :resize +2<CR>

nnoremap <Leader>" viw<ESC>bi"<ESC>ea"<ESC>
nnoremap <Leader>, mzA;<ESC>`z

nnoremap <leader>fr :call SourceAllVimRc()<CR>
" Search for word equal to each
nnoremap <leader>fd /\(\<\w\+\>\)\_s*\1<CR>
" Trim EOL trailing space
nnoremap <leader>W :%s/\s\+$//<CR>
nnoremap <leader>w :call GoToDefRSplit()<CR>

" Enter break line
nnoremap <leader><CR> i<CR><Esc>k$

nnoremap ss "*y

xnoremap <  <gv
xnoremap >  >gv

" === insert noremap ===
inoremap <C-d> <Esc>ddi
inoremap <C-z> <Esc>ui
inoremap <C-u> <C-G>u<C-U>
inoremap <C-k> <C-o>D

inoremap <C-b> <C-Left>
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

" === command noremap ===
" Complete absolute path of current file (before input the file)
cnoremap <C-t> <C-R>=GetAbsFileDir()<CR>

" === visual noremap ===
vnoremap <C-Up>   :move '<-2<CR>gv
vnoremap <C-Down> :move '>+<CR>gv
" use xclip to copy line(s) to system clipboard in visual mode
if executable('xclip')
    vnoremap <C-c> :silent w !xclip -selection clipboard<CR>
endif

vnoremap <leader>s "*y
vnoremap su "*p
" ====== maps ]]]1


" ====== custom command ======
command! -nargs=+ -complete=file CpGrep execute 'silent grep! <args>' | copen 9 | redraw!


" source other vimrc
let user2ndVim=$HOME . '/.vim/user2.vim'
if filereadable(user2ndVim) && ! has('nvim')
    exe 'source' user2ndVim
endif

" vim:fdm=marker:fmr=[[[,]]]
