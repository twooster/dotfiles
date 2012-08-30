" Modeline and Notes {
"   vim: set foldmarker={,} foldlevel=0 spell:
"
"   This is my personal .vimrc, I don't recommend you copy it, just 
"   use the "   pieces you want(and understand!).  When you copy a 
"   .vimrc in its entirety, weird and unexpected things can happen.
"
"   If you find an obvious mistake hit me up at:
"   http://robertmelton.com/contact (many forms of communication)
" }

" Basics {
    set nocompatible " explicitly get out of vi-compatible mode
    set noexrc " don't use local version of .(g)vimrc, .exrc
    set background=dark " we plan to use a dark background
    let mapleader="," " a sensible leader character
    syntax on " syntax highlighting on
" }

" General {
    filetype plugin indent on " load filetype plugins/indent settings
    set autochdir " always switch to the current file directory 
"    set undofile " undo across saves
    set ttyfast " derp
    set encoding=utf-8 " good default
    set backspace=indent,eol,start " make backspace a more flexible
    set fileformats=unix,dos,mac " support all three, in this order
    set hidden " you can change buffers without saving
    " (XXX: #VIM/tpope warns the line below could break things)
    set iskeyword+=_,$,@,%,# " none of these are word dividers 
    set mouse=a " use mouse everywhere
    set title " show title
    set noerrorbells " don't make noise
    set whichwrap=b,s,h,l,<,>,~,[,] " everything wraps
    "             | | | | | | | | |
    "             | | | | | | | | +-- "]" Insert and Replace
    "             | | | | | | | +-- "[" Insert and Replace
    "             | | | | | | +-- "~" Normal
    "             | | | | | +-- <Right> Normal and Visual
    "             | | | | +-- <Left> Normal and Visual
    "             | | | +-- "l" Normal and Visual (not recommended)
    "             | | +-- "h" Normal and Visual (not recommended)
    "             | +-- <Space> Normal and Visual
    "             +-- <BS> Normal and Visual
    set wildmenu " turn on command line completion wild style
    " ignore these list file extensions
    set wildignore=*.dll,*.o,*.obj,*.bak,*.exe,*.pyc,
                    \*.jpg,*.gif,*.png
    set wildmode=list:longest " turn on wild mode huge list
    set matchpairs=(:),{:},[:],<:>
" }

" Vim UI {
    colorscheme molokai
    set cursorline " highlight current line
    set incsearch " BUT do highlight as you type you 
                  " search phrase
    set laststatus=2 " always show the status line
    set lazyredraw " do not redraw while running macros
    set linespace=0 " don't insert any extra pixel lines 
                     " betweens rows
    set list " we do what to show tabs, to ensure we get them 
              " out of my files
    set listchars=tab:▸\ ,eol:¬
    set matchtime=5 " how many tenths of a second to blink 
                     " matching brackets for
    set nostartofline " leave my cursor where it was
    set visualbell " don't blink
    set number " turn on line numbers
    set numberwidth=4 " We are good up to 9999 lines
    set report=0 " tell us when anything is changed via :...
    set ruler " Always show current positions along the bottom
    set scrolloff=5 " Keep 10 lines (top/bottom) for scope
    set shortmess=aOstT " shortens messages to avoid 
                         " 'press a key' prompt
    set showcmd " show the command being typed
    set showmatch " show matching brackets
    set sidescrolloff=10 " Keep 5 lines at the size

    set statusline=
    set statusline+=%<\                       " cut at start
    set statusline+=%2*[%n%H%M%R%W]%*\        " flags and buf no
    set statusline+=%-40f\                    " path
    set statusline+=%=%1*%y%*%*\              " file type
    set statusline+=%10((%l,%c)%)\            " line and column
    set statusline+=%P                        " percentage of file
" }

" Text Formatting/Layout {
"    set completeopt= " don't use a pop up menu for completions
    set expandtab " no real tabs please!
    set formatoptions=rq " Automatically insert comment leader on return, 
                          " and let gq format comments
    set ignorecase " case insensitive by default
    set infercase " case inferred by default
    set nowrap " do not wrap line
    set shiftround " when at 3 spaces, and I hit > ... go to 4, not 5
    set smartcase " if there are caps, go case-sensitive
    set shiftwidth=4 " auto-indent amount when using cindent, 
                      " >>, << and stuff like that
    set softtabstop=4 " when hitting tab or backspace, how many spaces 
                       "should a tab be (see expandtab)
    set tabstop=8 " real tabs should be 8, and they will show with 
                   " set list on

    " Sets up past-80-column highlighting
    highlight OverLength ctermbg=red ctermfg=white guibg=#592929
    match OverLength /\%81v.\+/
    " Turn on all python highlighting
    let python_highlight_all = 1
    let python_slow_sync = 1
" }

" Folding {
"    set foldenable " Turn on folding
"    set foldmarker={,} " Fold C style code (only use this as default 
"                        " if you use a high foldlevel)
"    set foldmethod=marker " Fold on the marker
"    set foldlevel=100 " Don't autofold anything (but I can still 
"                      " fold manually)
"    set foldopen=block,hor,mark,percent,quickfix,tag " what movements
"                                                       " open folds 
"    function SimpleFoldText() " {
"        return getline(v:foldstart).' '
"    endfunction " }
"    set foldtext=SimpleFoldText() " Custom fold text function 
"                                   " (cleaner than default)
" }

" Plugin Settings {
    let b:match_ignorecase = 1 " case is stupid
" }

" Mappings {
    " space / shift-space scroll in normal mode
    noremap <S-space> <C-u>
    noremap <space> <C-d>
    nnoremap / /\v
    vnoremap / /\v
    " The 'I'm a newbie' section
    nnoremap <up> <nop>
    nnoremap <down> <nop>
    nnoremap <left> <nop>
    nnoremap <right> <nop>
    inoremap <up> <nop>
    inoremap <down> <nop>
    inoremap <left> <nop>
    inoremap <right> <nop>
    " The 'make moving around windows easy' section
    map <c-h> <c-w>h
    map <c-j> <c-w>j
    map <c-k> <c-w>k
    map <c-l> <c-w>l
    " The 'visual instead of logical lines' section
    nnoremap j gj
    nnoremap k gk
    " The "make buffer switching easy" section
    nnoremap <C-Tab> :bn<CR>
    nnoremap <C-S-Tab> :bp<CR>
    nnoremap \ :buf #<CR>
    nmap <leader>d :bprevious<CR>:bdelete #<CR>

    " Highlighting debuging: TODO: Remove
    map <C-F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
" }

" Autocommands {
    au FileType ruby setlocal tabstop=2 softtabstop=2 shiftwidth=4
    au FileType python setlocal tabstop=8 softtabstop=4 shiftwidth=4
    au FileTYpe javascript setlocal tabstop=4 softtabstop=4 shiftwidth=4
" }

" GUI Settings {
if has("gui_running")
    " Basics {
        colorscheme mustang
        set columns=120
        set guifont=Tamzen:h15
        set guioptions=ce 
        "              ||
        "              |+-- use simple dialogs rather than pop-ups
        "              +  use GUI tabs, not console style tabs
        set mousehide " hide the mouse cursor when typing
        set transp=4 " a little bit of transparency for macvim
    " }
endif
" }

call pathogen#infect()
