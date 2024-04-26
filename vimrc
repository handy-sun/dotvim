set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set termencoding=utf-8

if has('syntax')
    syntax on
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
set scrolloff=1                 " movement keep 3 lines when scrolling
set errorbells
" set novisualbell                " turn off visual bell
set visualbell t_vb=

set nobackup                    " do not keep a backup file
set noswapfile

" if undodir not set, create this dir and set it
let t:username = trim(system('id -unz'))
let t:undodir=expand('/tmp/vim.' . t:username . '/undo')
" echo t:undodir
if !isdirectory(t:undodir)
    silent! call mkdir(t:undodir, 'p')
endif

set undofile
exe 'set undodir=' . t:undodir


" show
""==set nu
set number                      " show line numbers
set ruler                       " show the current row and column
set showcmd                     " display incomplete commands
"set nowrap                      " auto linefeed
set showmode                    " display current modes
set showmatch                   " jump to matches when entering parentheses
set matchtime=1                 " tenths of a second to show the matching parenthesis
" show location
"set cursorcolumn                " highlight the whole column
set cursorline
set splitright
set splitbelow
set relativenumber
set background=dark

" indent
set autoindent
set cindent
set smartindent                 " ??? only for C language
set shiftround
" set shiftwidth=4
" tab
set tabstop=4                   " table key width
" set softtabstop=4                " insert mode tab and backspace use 4 spaces
"set noexpandtab                 " donnot use space relace tab
set smarttab                    " at the beginning of line and section?
" set expandtab                   " expand tabs to spaces

" search
set hlsearch                    " highlight searches
set incsearch                   " do incremental searching, search as you type
set ignorecase                  " !!! ignore case when searching
set smartcase                   " no ignorecase if Uppercase char present
set infercase

set fileformats=unix,dos,mac

" select & complete
set mouse=a                      " use mouse anywher in buffer"
set selection=exclusive          " selection donnot contain the last word
set selectmode=mouse,key

set completeopt=longest,menu            " coding complete with filetype check
set clipboard+=unnamed                  " share clipboard
set wildmenu                            " show a navigable menu for tab completion"
set wildmode=longest,list,full
set wildignore=.git,.hg,.svn,*.pyc,*.o,*.out,*.class,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**
set wildignorecase

set list
set listchars=tab:»·,trail:·,nbsp:+

" color & theme [begin]
set t_Co=256

hi MyTabSpace ctermfg=darkgrey
match MyTabSpace /\t\| /

" set mark column color
hi Search cterm=bold ctermbg=darkyellow
hi CursorLine cterm=NONE gui=NONE term=NONE
hi CursorLine ctermbg=240
hi LineNr ctermfg=darkgrey
hi CursorLineNr term=reverse cterm=bold ctermfg=lightgreen
hi! link SignColumn   LineNr
hi! link ShowMarksHLl DiffAdd
hi! link ShowMarksHLu DiffChange

let vim_install_path=$VIMRUNTIME
let theme_file=vim_install_path.'/colors/habamax.vim'
if filereadable(theme_file)
    colorscheme habamax
endif

" status line
set laststatus=2   " Always show the status line - use 2 lines for the status bar
set cmdheight=1    " cmdline which under status line height, default = 1

set statusline=
set statusline+=\%7*[%n]                                   " buffer number
set statusline+=\ %8*%<%.70F                               " file path maxlength
set statusline+=%=\ %1*\%y%m%r%h%w\ %*                     " [filetype] [show'+'ifmodified]
set statusline+=%5*\%{&ff}\[%{(&fenc==\"\")?&enc:&fenc}%*  " encoding
set statusline+=%5*\%{(&bomb?\",BOM\":\"\")}]\ %*          " encoding has BOM
set statusline+=%3*row:%l/%L\ col:%c\ %*                   " curRow/totalRow, curColumn
set statusline+=%4*\%3p%%\ %*                              " current line percent
set statusline+=%9*%{strftime(\"%H:%M\")}\ %*

"hi statusline ctermbg=darkgrey
hi User1 ctermfg=red ctermbg=darkgrey
hi User2 ctermfg=brown ctermbg=darkgrey
hi User3 ctermfg=yellow ctermbg=darkgrey
hi User4 ctermfg=green ctermbg=darkgrey
hi User5 ctermfg=cyan ctermbg=darkgrey
hi User6 ctermfg=blue ctermbg=darkgrey
hi User7 ctermfg=magenta ctermbg=darkgrey
hi User8 ctermfg=white ctermbg=darkgrey
hi User9 ctermfg=lightgrey ctermbg=darkgrey
" color & theme [end]

if has('autocmd')
augroup vimrcEx
    " --- Open file at the last edit line
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    " --- Auto source vimrc '/etc/vimrc', '/etc/vim/vimrc', $MYVIMRC
    "au BufReadPost * $VIM_PATH/{*.vim,*.yaml,vimrc} nested source $MYVIMRC | redraw
    " --- Autoreload .vim
    au BufWritePost,FileWritePost *.vim nested if &l:autoread > 0 | source <afile> | echo 'source ' . bufname('%') | endif
    " --- Check if file changed when its window is focus, more eager than 'autoread'
    au FocusGained * checktime
    " --- Highlight current line only on focused window
    au WinEnter,BufEnter,InsertLeave * if ! &cursorline && &filetype !~# '^\(dashboard\|clap_\)' && ! &pvw | setlocal cursorline | endif
    au WinLeave,BufLeave,InsertEnter * if &cursorline && &filetype !~# '^\(dashboard\|clap_\)' && ! &pvw | setlocal nocursorline | endif
    " --- These kind of files donnot set undofile    
    au BufWritePre /tmp/*,COMMIT_EDITMSG,MERGE_MSG,*.tmp,*.bak setlocal noundofile
    au BufRead,BufNew *.conf,*.config setf config
    au BufRead,BufNew *.log.* setf messages
    au FileType python set tabstop=4 shiftwidth=4 expandtab
    au FileType yaml set tabstop=2 shiftwidth=2 expandtab
    au FileType make set noexpandtab shiftwidth=8 softtabstop=0
    au FileType lua set noexpandtab shiftwidth=4 softtabstop=0
    au FileType cmake,systemd setlocal commentstring=#\ %s
augroup END
endif

" others
set backspace=indent,eol,start  " make that backspace key work the way it should
set whichwrap+=<,>,h,l          " allow backspace and cursor crossline border
set viminfo+=!      " save global variable
set report=0        " commands to tell user which line modified"
set fillchars=vert:\ ,stl:\ ,stlnc:\     " show blank between split window

set foldenable
set foldlevelstart=99
set foldmethod=manual

set langmenu=zh_CN.UTF-8
set helplang=en

" disable auto wrap and auto comments
set formatoptions-=co
set formatoptions+=mM

let &t_SI .= "\<Esc>[?2004h"   " start insert enable bracketed paste mode
let &t_EI .= "\<Esc>[?2004l"   " end insert disable bracketed paste mode

" keyborad bind
let mapleader = "\<space>"

" ------- normal noremap -------
nnoremap <silent> <S-Tab> :normal za<CR>
nnoremap <space>s :w<CR>
nnoremap <space>q :wq<CR>
nnoremap <space><bs> :wqa<CR>
nnoremap <space>e :q!<CR>
nnoremap <C-a> ggVG
" nnoremap <space>2 @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

" cancel highlight search word
nnoremap <silent> <leader><space> :nohlsearch<CR>
" goto next search result and focus on this line
nnoremap n nzz
" goto previous search result and focus on this line
nnoremap N Nzz

" Yank text to EOL
nnoremap <silent> Y y$

" move current line down
nnoremap <A-Down> :m +1<CR>
" move current line up
nnoremap <A-Up> :m -2<CR>

nnoremap <leader><Up> yyP
nnoremap <leader><Down> yyp


nnoremap tn :tabnew<CR>
nnoremap tk :tabnext<CR>
nnoremap tj :tabprevious<CR>
nnoremap to :tabonly<CR>
nnoremap tc :tabclose<CR>

nnoremap sc "ayiw
nnoremap sp viw"ap
nnoremap sw "ayiW
nnoremap s[ viW"ap
nnoremap sa :%s/<C-R>a//g<Left><Left>
nnoremap s/ :%s/<C-R>///g<Left><Left>

nnoremap se :e <C-R>=expand('%:p:h') . '/' <CR>
nnoremap sh :setlocal nosplitright<CR>:vsplit <C-R>=expand('%:p:h') . '/' <CR>
nnoremap sl :setlocal splitright<CR>:vsplit <C-R>=expand('%:p:h') . '/' <CR>
nnoremap sk :setlocal nosplitbelow<CR>:split <C-R>=expand('%:p:h') . '/' <CR>
nnoremap sj :setlocal splitbelow<CR>:split <C-R>=expand('%:p:h') . '/' <CR>

nnoremap <C-h> :wincmd h<CR>
nnoremap <C-l> :wincmd l<CR>
nnoremap <C-j> :wincmd j<CR>
nnoremap <C-k> :wincmd k<CR>

nnoremap <leader>[ :vertical resize -4<CR>
nnoremap <leader>] :vertical resize +4<CR>
nnoremap <leader>; :resize -2<CR>
nnoremap <leader>' :resize +2<CR>

nnoremap <leader>fr :call SourceAllVimRc()<CR>
" Search for word equal to each
nnoremap <leader>fd /\(\<\w\+\>\)\_s*\1
" Trim EOL trailing space
nnoremap <leader>W :%s/\s\+$//<CR>:let @/=''<CR>
" Enter break line
nnoremap <leader><CR> i<CR><Esc>k$

xnoremap <  <gv
xnoremap >  >gv

" ------- insert noremap -------
inoremap <C-d> <Esc>ddi
inoremap <leader>z <Esc>ui
inoremap <C-u> <C-G>u<C-U>
inoremap <C-k> <C-o>D

inoremap <C-b> <C-Left>
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

" ------- command noremap
" Complete absolute path of current file (before input the file)
cnoremap <C-t> <C-R>=expand("%:p:h") . "/" <CR>

" ------- visual noremap -------
let t_ExistOutput = system('command -v xclip')
if strlen(t_ExistOutput) > 0
    vnoremap <C-c> :silent w !xclip -selection clipboard<CR>
    vnoremap <leader>c :silent w !xclip -selection clipboard<CR>
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
