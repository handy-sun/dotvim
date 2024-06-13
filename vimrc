set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set termencoding=utf-8

set fileformats=unix,dos,mac

filetype plugin indent on       " Load plugins according to detected filetype.
if has('syntax')
    syntax on
endif

if has('multi_byte') && &encoding ==# 'utf-8'
    let t:isMultiByte = 1
else
    let t:isMultiByte = 0
endif

" filetype
filetype on
filetype plugin on              " Enable filetype plugins
filetype indent on              " load specific type indent file

" base
set nocompatible                " don't bother with vi compatibility
set autoread                    " reload files when changed on disk
set autowrite
set gdefault
set confirm                     " processing ont save or read-only file, pop confirm
set shortmess=aTI
set magic                       " For regular expressions turn magic on
set title                       " change the terminal's title
set history=1000                " history : how many lines of history VIM has to remember
set scrolloff=5                 " movement keep x lines when scrolling
set errorbells
set visualbell t_vb=

set timeout           " for mappings
set timeoutlen=1000   " default value
set ttimeout          " for key codes
set ttimeoutlen=10    " unnoticeable small value

" set nobackup                    " do not keep a backup file
set nowritebackup

let t:cacheVim=$HOME . '/.cache/vim'

let t:undoDir=t:cacheVim . '/undo'
let t:swapDir=t:cacheVim . '/swap'
let t:bakDir=t:cacheVim . '/backup'
let t:vimInfoFile=t:cacheVim . '/viminfo'

" undo dir
if has('persistent_undo')
    let &undodir=t:undoDir
    if !isdirectory(&undodir)
        silent! call mkdir(&undodir, 'p')
    endif
    set undofile
endif

" swap dir
let &directory=t:swapDir
if !isdirectory(&directory)
    silent! call mkdir(&directory, 'p')
endif
set swapfile

" backup dir
let &backupdir=t:bakDir
if !isdirectory(&backupdir)
    silent! call mkdir(&backupdir, 'p')
endif

let &viminfo.=',!'              " save global variable
let &viminfo.=',n' . t:vimInfoFile

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
set smartindent                 " ??? only for C language
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
set clipboard^=unnamed,unnamedplus
set wildmenu                            " show a navigable menu for tab completion
set wildmode=longest,list,full
set wildignore=.git,.hg,.svn,*.pyc,*.o,*.out,*.class,*.jpg,*.jpeg,*.png,*.gif,*.zip,*build*,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**
set wildignorecase

if t:isMultiByte
    let &listchars = 'tab:»·,trail:•,extends:❯,precedes:❮,nbsp:±'
    let &fillchars = 'vert: ,stl: ,stlnc: ,diff: '
    let &showbreak = '⣿'
else
    let &listchars = 'tab:> ,trail:.,extends:>,precedes:<,nbsp:+'
    let &fillchars = 'vert: ,stlnc:#'
    let &showbreak = '->'
endif

" --- color & theme {{{1
set t_Co=256

hi MyTabSpace ctermfg=darkgrey
match MyTabSpace /\t\| /

let vim_install_path=$VIMRUNTIME
let theme_file=vim_install_path . '/colors/habamax.vim'
let theme_2nd_file=vim_install_path . '/colors/peachpuff.vim'

if filereadable(theme_file)
    colorscheme habamax
elseif filereadable(theme_2nd_file)
    colorscheme peachpuff
endif

" set mark column color
hi Search cterm=bold ctermbg=darkyellow
hi CursorLine cterm=NONE gui=NONE term=NONE
hi CursorLine ctermbg=240
hi CursorLineNr term=reverse cterm=bold ctermfg=brown
hi! LineNr ctermfg=darkgrey term=reverse
hi! link SignColumn   LineNr
hi! link ShowMarksHLl DiffAdd
hi! link ShowMarksHLu DiffChange

" status line {{{2
set laststatus=2   " Always show the status line - use 2 lines for the status bar
set cmdheight=1    " cmdline which under status line height, default = 1

let &statusline ='%7*[%n] %*'
let &statusline.='%8*%<%.70F %*'
let &statusline.='%1*%= %y%m%r%h%w %*'
let &statusline.='%5*%{&ff}[%{&fenc!=""?&fenc:&enc}%{&bomb?",BOM":""}] %*'
if t:isMultiByte
    let &statusline.='%4*%{&et?"•":"»"} sw:%{&sw},ts:%{&ts},sts:%{&sts} %*'
else
    let &statusline.='%4*%{&et?"|":">"} sw:%{&sw},ts:%{&ts},sts:%{&sts} %*'
endif
let &statusline.='%3*row:%l/%L col:%c %*'
let &statusline.='%4*%3p%% %*'
let &statusline.='%9*%{strftime("%H:%M")} %*'
let &statusline.='%#ErrorMsg#%{&paste?" paste ":""}%*'

hi User1 ctermbg=darkgrey ctermfg=red
hi User2 ctermbg=darkgrey ctermfg=brown
hi User3 ctermbg=darkgrey ctermfg=yellow
hi User4 ctermbg=darkgrey ctermfg=green
hi User5 ctermbg=darkgrey ctermfg=cyan
hi User6 ctermbg=darkgrey ctermfg=blue
hi User7 ctermbg=darkgrey ctermfg=magenta
hi User8 ctermbg=darkgrey ctermfg=white
hi User9 ctermbg=darkgrey ctermfg=lightgrey
" status line }}}2
" color & theme }}}1

if has('autocmd')
augroup vimrcEx
    " --- Open file at the last edit line
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"zvzz" | endif
    " --- Autoreload .vim
    au BufWritePost,FileWritePost *.vim nested if &l:autoread > 0 | source <afile> | echo 'source ' . bufname('%') | endif
    " --- Check if file changed when its window is focus, more eager than 'autoread'
    au FocusGained * checktime
    " au BufWinEnter * normal! zvzz
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
    au FileType help wincmd L | vertical resize -10
augroup END
endif

" --- others
set backspace=indent,eol,start  " make that backspace key work the way it should
set whichwrap+=<,>,h,l          " allow backspace and cursor crossline border
set report=0                    " commands to tell user which line modified

if has('folding')
    set foldenable
    set foldlevelstart=99
    set foldmethod=manual
endif

set langmenu=zh_CN.UTF-8
set helplang=en

" disable auto wrap and auto comments
" set formatoptions-=co
" set formatoptions+=mM
set formatoptions=croqn2mB1
set sessionoptions=blank,buffers,curdir,folds,help,options,tabpages,winsize,slash,unix,resize

if empty($TMUX)
    let &t_SI = "\<Esc>]50;CursorShape=1\x7\<Esc>[?2004h"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7\<Esc>[?2004l"
    " let &t_SR = "\<Esc>]50;CursorShape=2\x7"
else
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
    " let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
endif

let &grepprg = 'grep -rn $*'

" keyborad bind
let mapleader = "\<space>"

" ------- normal noremap -------
nnoremap <space>s :w<CR>
nnoremap <space>q :wq<CR>
nnoremap <space><bs> :wqa<CR>
nnoremap <space>e :q!<CR>
nnoremap <C-a> ggVG
" nnoremap <space>2 @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

" cancel highlight search word and clean screen
nnoremap <silent> <leader><space> :nohlsearch<CR>:diffupdate<CR>:syntax sync fromstart<CR><C-l>

" always goto backward search result
nnoremap <expr> n  'Nn'[v:searchforward]
" always goto forward search result
nnoremap <expr> N  'nN'[v:searchforward]

nnoremap g; g;zvzz
nnoremap g, g,zvzz

" Yank text to EOL
nnoremap <silent> Y y$

" move current line up and down
nnoremap <A-Up>   :<c-u>execute 'move -1-' . v:count1<CR>
nnoremap <A-Down> :<c-u>execute 'move +' . v:count1<CR>
vnoremap <A-Up>   :m '<-2<CR>gv
vnoremap <A-Down> :m '>+<CR>gv
" add lots of line(s)
nnoremap [\  :<c-u>put! =repeat(nr2char(10), v:count1)<CR>'[
nnoremap ]\  :<c-u>put =repeat(nr2char(10), v:count1)<CR>

nnoremap <leader><Up> yyP
nnoremap <leader><Down> yyp

nnoremap zr :registers<CR>
nnoremap zm :marks<CR>:mark 

nnoremap tn :tabnew<CR>
nnoremap tk :tabnext<CR>
nnoremap tj :tabprevious<CR>
nnoremap to :tabonly<CR>
nnoremap tc :tabclose<CR>

nnoremap sc "ayiw
nnoremap sp viw"ap
nnoremap sw "byiW
nnoremap s[ viW"bp
nnoremap sa :%s/<C-R>a//g<Left><Left>
nnoremap s/ :%s/<C-R>///g<Left><Left>

nnoremap se :e <C-R>=expand('%:p:h') . '/' <CR>
nnoremap st :tabnew <C-R>=expand('%:p:h') . '/' <CR>
nnoremap sh :setlocal nosplitright<CR>:vsplit <C-R>=expand('%:p:h') . '/' <CR>
nnoremap sl :setlocal splitright<CR>:vsplit <C-R>=expand('%:p:h') . '/' <CR>
nnoremap sk :setlocal nosplitbelow<CR>:split <C-R>=expand('%:p:h') . '/' <CR>
nnoremap sj :setlocal splitbelow<CR>:split <C-R>=expand('%:p:h') . '/' <CR>

nnoremap <leader>[ :vertical resize -4<CR>
nnoremap <leader>] :vertical resize +4<CR>
nnoremap <leader>; :resize -2<CR>
nnoremap <leader>' :resize +2<CR>

nnoremap <leader>fr :call SourceAllVimRc()<CR>
" Search for word equal to each
nnoremap <leader>fd /\(\<\w\+\>\)\_s*\1<CR>
" Trim EOL trailing space
nnoremap <leader>W :%s/\s\+$//<CR>

" Enter break line
nnoremap <leader><CR> i<CR><Esc>k$

xnoremap <  <gv
xnoremap >  >gv

" ------- insert noremap -------
inoremap <C-d> <Esc>ddi
inoremap <C-z> <Esc>ui
inoremap <C-u> <C-G>u<C-U>
inoremap <C-k> <C-o>D

inoremap <C-b> <C-Left>
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

" ------- command noremap ------- 
" Complete absolute path of current file (before input the file)
cnoremap <C-t> <C-R>=expand("%:p:h") . "/" <CR>

" ------- visual noremap -------
" use xclip to copy line(s) to system clipboard in visual mode
if executable('xclip')
    vnoremap <C-c> :silent w !xclip -selection clipboard<CR>
endif

" ------- custom function -------
function! XTermPasteBegin()
    set pastetoggle=<Esc>[201~
    set paste
    return ''
endfunction

if !exists('*SourceAllVimRc')
    function! SourceAllVimRc()
        let l:finls = ''
        exe 'wa'
        for file in ['/etc/vimrc', '/etc/vim/vimrc', $MYVIMRC]
            if filereadable(expand(file))
                exe 'source' file
                let l:finls = l:finls.' '.file
            endif
        endfor
        exe 'noh'
        echo 'sourced files:' . l:finls
    endfunction
endif

let user2ndVim=$HOME . '/.vim/vimrc'
if filereadable(user2ndVim)
    exe 'source' user2ndVim
endif

" vim:fdm=marker:fmr={{{,}}}
