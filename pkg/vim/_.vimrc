" Modeline and Notes {
"   vim: shiftwidth=4
"
"   Originally by Robert Melton, modified heavily
" }


if empty($XDG_CACHE_HOME)
    let $XDG_CACHE_HOME=$HOME."/.cache"
endif

if empty($XDG_CONFIG_HOME)
    let $XDG_CONFIG_HOME=$HOME."/.config"
endif

" Basics {
    set nocompatible       " explicitly get out of vi-compatible mode
    set noexrc             " don't use local version of .(g)vimrc, .exrc
    set background=dark    " we plan to use a dark background

    let mapleader="\<Tab>" " not a sensible leader character, but can't map
                           " space directly
    " And this makes space work:
    map <Space> <Leader>
" }

" General {
"    set autochdir                  " always switch to the current file directory
    filetype plugin indent on       " load filetype plugins/indent settings
    set autoread                    " always load updated files
    set backspace=indent,eol,start  " make backspace a more flexible
    set encoding=utf-8              " good default
    set fileformats=unix,dos,mac    " support all three, in this order
    set hidden                      " you can change buffers without saving
    set iskeyword+=_,$,@            " none of these are word dividers
    set matchpairs=(:),{:},[:],<:>  " some sane matchpairs
    set noerrorbells                " don't make noise
    set title                       " show title
    set ttyfast                     " derp
    set smarttab
    set langnoremap
    set whichwrap=b,s,~

    set wildmenu                    " turn on command line completion wild style
    " ignore these list file extensions
    set wildignore=*.dll,*.o,*.obj,*.bak,*.exe,*.pyc,
                    \*.jpg,*.gif,*.png,.git,*.swp
    set wildmode=list:longest       " turn on wild mode huge list

    " Thanks to Wincent's vimrc for this
    if has('persistent_undo')
        set undodir=$XDG_CACHE_HOME/vim/undo//,.   " keep undo files out of the way
        set undofile                           " actually use undo files
    endif

    " For swap files
    set directory=$XDG_CACHE_HOME/vim/swap//,.


    " Makes vim always overwrite the existing file when saving (rather than
    " doing a copy/rename); this is 'slower' but shouldn't matter on modern
    " machines, and plays nicely with common file-watching/rebuild strategies
    set backupcopy=yes
    set backupdir=$XDG_CACHE_HOME/vim/backup//,.

    if !has('nvim')
        set viminfo+='1000,n$XDG_CACHE_HOME/vim/viminfo
    endif
    set runtimepath=$XDG_CONFIG_HOME/vim,$VIM,$VIMRUNTIME,$XDG_CONFIG_HOME/vim/after

    set mouse=a
" }

" Vim UI {
    syntax on                   " syntax highlighting on
    colorscheme molokai " monokai-phoenix

    set cursorline              " highlight current line
    set incsearch               " highlight as search phrase typed
    set laststatus=2            " always show the status line
    set lazyredraw              " do not redraw while running macros
    set list                    " show special characters
    " See autocmds for Go, where we drop the tab character
    let s:other_list_chars = "eol:¬,extends:»,precedes:«,trail:•"
    let &g:listchars="tab:▸\ ," . s:other_list_chars
    set matchtime=1             " how many tenths of a second to blink
                                " matching brackets for
    set nostartofline           " leave my cursor where it was

    set visualbell              " we <3 blinking...
    set t_vb=                   " ...not

    set number                  " turn on line numbers
    set numberwidth=4           " good up to 9999 lines
    set report=0                " tell us when anything is changed via :...
    set ruler                   " always show current positions along the bottom
    set scrolloff=7             " keep X lines (top/bottom) for scope

    set shortmess=a             " shorten the file-status indicators
    set shortmess+=O            " warn on reading will overwrite buffer changes
    set shortmess+=s            " no 'search hit BOTTOM' message
    set shortmess+=tT           " truncate some messages to fit on single line
    set shortmess+=I            " no vim intro message
    set shortmess+=c            " Don't pass messages to |ins-completion-menu|.

    " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
    " delays and poor user experience.
    set updatetime=300

    set signcolumn=yes

    set showcmd                 " show the command being typed
    set showmatch               " show matching brackets
    set sidescrolloff=10        " keep X characters at the sides
    set hlsearch
    set history=10000

    set cmdheight=2

    set statusline=
    set statusline+=%<\                       " cut at start
    set statusline+=%2*[%n%H%M%R%W]%*\        " flags and buf no
    set statusline+=%-40F\                    " path
    set statusline+=%=%1*%y%*%*\              " file type
    set statusline+=%10((%l,%c)%)\            " line and column
    set statusline+=%P                        " percentage of file

    " [via Shane da Silva's dotfiles, and seen elsewhere]
    " Disable Background Color Erase (BCE) so that color schemes
    " work properly when Vim is used inside tmux and GNU screen.
    if &term =~ '256color'
        if !has('nvim')
            set t_ut=
        endif
    endif

    "hi Normal guibg=NONE ctermbg=NONE
    "hi CursorLine guibg=NONE ctermbg=NONE
" }

" Text Formatting/Layout {
"    set completeopt= " don't use a pop up menu for completions
    set expandtab          " no real tabs please!
    set formatoptions+=q   " Allow commenting formatting with 'gq'
    set formatoptions+=r   " Insert comment leader after hitting <enter> in INS
    set formatoptions+=j   " Remove comment leader when joining lines
    set ignorecase         " insert completion case insensitive by default
    set infercase          " insert completion case inferred by default
    set nowrap             " do not wrap line
    "set shiftround         " when at 3 spaces, and I hit > ... go to 4, not 5
    set shiftwidth=2       " auto-indent amount when using cindent,
    set smartcase          " if there are caps, go case-sensitive when searching
    set smartindent        " Slightly smarter indentation
    "set autondent          " Previous line indentation
    "set cindent            " Smarter still
    set softtabstop=2      " tab converted to X spaces
    set tabstop=8          " real tabs X spaces wide

    " Sets up past-80-column highlighting
    if &t_Co > 255
        highlight OverLength1 ctermbg=52 guibg=#592929
        highlight OverLength2 ctermbg=88 guibg=#693939
    else
        highlight OverLength1 ctermbg=1
        highlight OverLength2 ctermbg=9
    endif
    match OverLength1 /\%81v.\+/
    2match OverLength2 /\%101v.\+/

    " Python syntax highlighting {
        let python_highlight_all = 1
        let python_slow_sync = 1
    " }

" }

" Folding {
    set foldmethod=syntax
    set foldlevel=99
" }

" Plugins {
    call plug#begin($XDG_CONFIG_HOME.'/vim/plugged')

    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-surround'
    Plug 'junegunn/vim-easy-align'
    Plug 'scrooloose/nerdcommenter'
    Plug 'easymotion/vim-easymotion'

    if has('nvim')

        " Syntax highlighting
        Plug 'leafgarland/typescript-vim'  ", { 'for': 'javascript' }
        "Plug 'HerringtonDarkholme/yats.vim'

        " Completion
        "Plug 'neoclide/coc.nvim', {'branch': 'release'}
        " {
    "
            " " Use tab for trigger completion with characters ahead and navigate.
            " " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
            " " other plugin before putting this into your config.
            " inoremap <silent><expr> <TAB>
            "       \ pumvisible() ? "\<C-n>" :
            "       \ <SID>check_back_space() ? "\<TAB>" :
            "       \ coc#refresh()
            " inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
            "
            " function! s:check_back_space() abort
            "   let col = col('.') - 1
            "   return !col || getline('.')[col - 1]  =~# '\s'
            " endfunction
            "
            " " Use <c-space> to trigger completion.
            " inoremap <silent><expr> <c-space> coc#refresh()
            "
            " " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
            " " position. Coc only does snippet and additional edit on confirm.
            " if has('patch8.1.1068')
            "   " Use `complete_info` if your (Neo)Vim version supports it.
            "   inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
            " else
            "   imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
            " endif
        " }
        " Plug 'ycm-core/YouCompleteMe', {'do': 'python3 install.py --go-completer --ts-completer'}

        " Or:
        "Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
        "Plug 'Shougo/deoplete.nvim'

        "let g:deoplete#enable_at_startup = 1
        "let g:nvim_typescript#diagnostics_enable = 0

        "map <Leader>o :call deoplete#toggle()<CR>
        "map <c-]> :TSTypeDef<CR>
        "map <Leader>p :TSDefPreview<CR>
        "map K :TSDoc<CR>
    else
        Plug 'Quramy/tsuquyomi'
        Plug 'mxw/vim-jsx'                 ", { 'for': 'javascript' }
        Plug 'leafgarland/typescript-vim'  ", { 'for': 'javascript' }
    endif

    "Plug 'Yggdroot/indentLine'

    Plug 'christoomey/vim-tmux-navigator'
    " The 'make moving around windows easy' section
    "noremap <C-h> <C-w>h
    "noremap <C-j> <C-w>j
    "noremap <C-k> <C-w>k
    "noremap <C-l> <C-w>l


    Plug 'dag/vim-fish'

    Plug 'tpope/vim-fugitive'

    Plug 'tpope/vim-rails'             ", { 'for': 'ruby' }
    Plug 'fatih/vim-go'                ", { 'for': 'go' }
    Plug 'tpope/vim-markdown'          ", { 'for': 'markdown' }
    Plug 'tpope/vim-haml'              ", { 'for': 'haml' }
    Plug 'elixir-lang/vim-elixir'      ", { 'for': 'elixir' }
    Plug 'pangloss/vim-javascript'     ", { 'for': 'javascript' }
"    Plug 'lepture/vim-jinja'           ", { 'for': 'jinja' }
    Plug 'mustache/vim-mustache-handlebars'
    Plug 'fgsch/vim-varnish'

    Plug 'junegunn/fzf.vim'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

    Plug 'hashivim/vim-terraform'

    Plug 'udalov/kotlin-vim'

    " From this discussion ... I like the install guard:
    " https://github.com/Valloric/YouCompleteMe/issues/1751
    function! BuildYCM(info)
        " info is a dictionary with 3 fields
        " - name:   name of the plugin
        " - status: 'installed', 'updated', or 'unchanged'
        " - force:  set on PlugInstall! or PlugUpdate!
        if a:info.status == 'installed' || a:info.force
          !./install.py --ts-completer --go-completer
        endif
    endfunction

"    Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }

    call plug#end()
" }


" scrooloose/nerdcommenter settings {
    let g:NERDSpaceDelims = 1
" }

" fatih/vim-go settings {
    let g:go_highlight_extra_types = 1
    let g:go_highlight_fields = 1
    let g:go_highlight_types = 1
    let g:go_highlight_operators = 1
    let g:go_highlight_functions = 1
    let g:go_highlight_function_calls = 1
    let g:go_highlight_format_strings = 1
    "let g:go_highlight_variable_declarations = 1
    "let g:go_highlight_variable_assignments = 1
" }

" christoomey/vim-tmux-navigator settings {
    let g:tmux_navigator_disable_when_zoomed = 1
" }

" IndentLine settings {
    let g:indentLine_char = '┆'
    let g:indentLine_color_term = 52
    "let g:indentLine_bgcolor_term = 233
" }

" Matchit Settings {
    let b:match_ignorecase = 1 " case is stupid
" }

" FZF settings {

    map <Leader>t :Files<CR>
    map <Leader>l :Lines<CR>
    map <Leader>b :Buffers<CR>
    map <Leader>g :Rg<Space>
" }

"" Syntastic Settings {
"    let g:syntastic_haml_checkers = ['haml_lint']
"" }


"" NERDTree Settings {
"    let NERDTreeIgnore = ['\.pyc$']
"
"    map <Leader>N :NERDTreeToggle<CR>
"    map <Leader>n :NERDTree<CR>
"" }

" NERDCommenter Settings {
    let g:NERDCommentEmptyLines = 1
    let g:NERDDefaultAlign = 'left'
" }

" Basic mappings {
    " The 'I hate esc' section
    imap jj <esc>

    " The 'make Y behave like C and D" section
    nnoremap Y y$

    " The 'sane searching' section
    nnoremap / /\v
    vnoremap / /\V%

    " The fuck netrw section
    map - <Nop>

    " The F1-is-too-close-to-esc section
    noremap <F1> <esc>
    noremap! <F1> <esc>
    cnoremap <F1> <C-C>

    " The 'visual instead of logical lines' section
    nnoremap j gj
    nnoremap k gk

    " When pasting over a selection, make sure we don't actually
    " lose our yanked value
    vnoremap p pgvygvv

    " The 'make switching quote-types easy' section
    nmap <Leader>' mzcs"'`z
    nmap <Leader>" mzcs'"`z

    " The colons are hard section
    map <Leader>; :
    map <Leader>q :q<CR>
    map <Leader>w :w<CR>
    map <Leader>x :x<CR>

    " The linux clipboard section
    "if has('clipboard')
    "  map <Leader>y :let @*=@"<cr>:echo Copied to system Clipboard<cr>
    "  nnoremap <Leader>p "*p
    "  nnoremap <Leader>P "*P
    "else
      map <Leader>y "zy:call system('setclip', getreg('z', 1, 1))<cr>
      map <Leader>p :r  !getclip<cr>
      map <Leader>P k:r !getclip<cr>
    "endif

    " Delete current buffer, move to previous
    nmap <leader>D :bprevious<CR>:bdelete! #<CR>

    " Zoom / Restore window.
    function! s:ZoomToggle() abort
        if exists('t:zoomed') && t:zoomed
            execute t:zoom_winrestcmd
            let t:zoomed = 0
        else
            let t:zoom_winrestcmd = winrestcmd()
            resize
            vertical resize
            let t:zoomed = 1
        endif
    endfunction
    command! ZoomToggle call s:ZoomToggle()
    nnoremap <silent> <Leader>z :ZoomToggle<CR>


    " Highlighting debugging:
    map <C-F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

    " Sort lines inside current paragraph
    "nmap <Leader>s mzvi}:sort<CR>`z
    " Sort selected lines
    vmap <Leader>s :sort<CR>

    " The 'Make splitting more like tmux' section
    nmap <Leader>\     :vsp<CR>
    nmap <Leader><Bar> :vsp<CR>
    nmap <Leader>-     :sp<CR>

    " Command mode readline mappings
    cnoremap <C-a> <Home>
    cnoremap <C-e> <End>

    " redraw arg!
    nmap <Leader>r :redraw!<CR>

    " Folding...
    "nnoremap <Leader>f za
" }

" EasyMotion Settings {
    let g:EasyMotion_do_mapping=0  " Disable default mappings
    let g:EasyMotion_smartcase=1
    let g:EasyMotion_use_smartsign_us=1
    let g:EasyMotion_startofline=0

    map  <C-s>     <Plug>(easymotion-overwin-f)
    map  <C-a>     <Plug>(easymotion-overwin-f2)
    nmap <Leader>/ <Plug>(easymotion-sn)
    omap <Leader>/ <Plug>(easymotion-tn)

    map  <Leader>h  <Plug>(easymotion-linebackward)
    map  <Leader>k  <Plug>(easymotion-k)
    map  <Leader>j  <Plug>(easymotion-j)
    map  <Leader>l  <Plug>(easymotion-lineforward)

"    map  <C-w>     <Plug>(easymotion-bd-w)
    map  <C-f>     <Plug>(easymotion-bd-f)
    map  <C-t>     <Plug>(easymotion-bd-t)
" }

" vim-easy-align settings {
    " Start interactive EasyAlign in visual mode (e.g. vipga)
    xmap <Leader>a <Plug>(EasyAlign)
    "
    " " Start interactive EasyAlign for a motion/text object (e.g. gaip)
    nmap <Leader>a <Plug>(EasyAlign)
" }

" Also from @sds by way of @wincent, by way of ?
" Support 'bracketed-paste' mode, allowing pasting large chunks of text without
" having to manually activate PASTE mode.
if &term =~ "xterm.*" || &term =~ "screen-*" || &term =~ "tmux-*"
    let &t_ti = &t_ti . "\e[?2004h"
    let &t_te = "\e[?2004l" . &t_te

    function! XTermPasteBegin(ret)
        set pastetoggle=<Esc>[201~
        set paste
        return a:ret
    endfunction

    map  <expr>     <Esc>[200~ XTermPasteBegin("i")
    imap <expr>     <Esc>[200~ XTermPasteBegin("")
    cmap <Esc>[200~ <nop>
    cmap <Esc>[201~ <nop>
endif

" Autocommands {
    " Salt state files:
    au BufNewFile,BufRead *.sls setlocal filetype=yaml
    au BufNewFile,BufRead *.vue setlocal filetype=html

    au FileType ruby       setlocal tabstop=2 softtabstop=2 shiftwidth=2
    au FileType python     setlocal tabstop=8 softtabstop=4 shiftwidth=4 cindent
                       \ | syn keyword pythonAwait await
                       \ | hi def link pythonAwait Keyword
                       \ | syn keyword pythonAsync async
                       \ | hi def link pythonAsync Keyword
    au FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2 cindent
    au FileType typescript setlocal signcolumn=yes
    au FileType css        setlocal tabstop=2 softtabstop=2 shiftwidth=2
    au FileType php        setlocal noet shiftwidth=2 softtabstop=2 tabstop=2
    au FileType go         setlocal noet shiftwidth=4 tabstop=4
                       \ | let &l:listchars = "tab:\ \ ," . s:other_list_chars
    au FileType gitcommit  setlocal textwidth=70 fo+=t

    fun! StripTrailingWhitespace()
        " Don't strip on these filetypes
        if &ft =~ '^diff$'
            return
        endif
        %s/\s\+$//e
    endfun

    " Remove all trailing whitespace on save
    autocmd BufWritePre * call StripTrailingWhitespace()

    " disable paste mode on leaving insert mode (thanks @wincent)
    au InsertLeave * set nopaste
" }

" GUI Settings {
if has("gui_running")
    set linespace=0             " don't insert any extra pixel lines
                                " betweens rows
    " Basics {
        set columns=120
        set guioptions=ce
        "              ||
        "              |+-- use simple dialogs rather than pop-ups
        "              +  use GUI tabs, not console style tabs
        set mousehide " hide the mouse cursor when typing
        set transp=4 " a little bit of transparency for macvim
    " }
endif
" }
