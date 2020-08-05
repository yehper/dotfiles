""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.config/nvim/plugged')
"tools
    Plug 'junegunn/goyo.vim' " no-distraction mode
    Plug 'ctrlpvim/ctrlp.vim' " Fuzzy search, MRU, and Buffer viewer
    Plug 'maxbrunsfeld/vim-yankstack' " multiple yanks
    Plug 'itchyny/lightline.vim' " equivalent to powerline
    Plug 'airblade/vim-gitgutter' " Viewing git changes
    Plug 'junegunn/limelight.vim' " Fucus on block
    Plug 'scrooloose/nerdtree' " fm integration
    Plug 'Xuyuanp/nerdtree-git-plugin' " visual git status for nerdtre visual git status for nerdtree

    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " Fuzzy finder for vim
    Plug 'junegunn/fzf.vim'
    Plug 'vim-scripts/TaskList.vim'
"syntax
    Plug 'tpope/vim-markdown' " markdown support
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']} " markdown preview
    " TODO 04/08/20 10:41 > need to fix markdown-preview not working
    Plug 'neoclide/coc.nvim', {'branch': 'release'} " completion and more
    Plug 'tpope/vim-surround' " surround with quotes

"color-schemes
    Plug 'blueshirts/darcula'
    Plug 'morhetz/gruvbox'
"    Plug 'chriskempson/base16-default-schemes'
    Plug 'chriskempson/base16-vim'
call plug#end()

"ctrlp
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'

"Nerd Tree
let g:NERDTreeWinPos = "right"
let NERDTreeShowHidden=1
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let g:NERDTreeWinSize=35
let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

"lightline

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ ['mode', 'paste'],
      \             ['fugitive', 'readonly', 'filename', 'modified'] ],
      \   'right': [ [ 'lineinfo' ], ['percent'], ['filetype'] ]
      \ },
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"🔒":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
      \ },
      \ 'component_function': {
      \   'filename': 'FilenameForLightline',
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ 'separator': { 'left': ' ', 'right': ' ' },
      \ 'subseparator': { 'left': ' ', 'right': ' ' }
  \ }
function! FilenameForLightline() " Show full path of filename
    return expand('%')
endfunction

"Goyo settings
function! s:goyo_enter()
    set noshowmode
    set noshowcmd
    set nocursorline
    CocDisable
    Limelight
endfunction

function! s:goyo_leave()
    set showmode
    set showcmd
    set cursorline
    CocEnable
    Limelight!
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" COC 
let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-pairs',
  \ 'coc-tsserver',
  \ 'coc-eslint', 
  \ 'coc-prettier', 
  \ 'coc-python', 
  \ 'coc-json' 
  \ ]
command! -nargs=0 Prettier :CocCommand prettier.formatFile

"prettier
"autocmd! bufWrite * Prettier

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set encoding=UTF-8
set ffs=unix,dos,mac " Use Unix as the standard file type
filetype plugin indent on
syntax enable
set history=500 " Sets how many lines of history VIM has to remember
set hidden " Sets buffers are hidden instead of closed when moved from
set autoread " Set to auto read when a file is changed from the outside
set so=7 " Set 7 lines to the cursor - when moving vertically using j/k
set wildmenu " Turn on the Wild menu
set wildignore=*.o,*~,*.pyc " Ignore compiled files
set ruler "Always show current position
set lbr " Linebreak on 500 characters
set tw=500
set mouse=a
set clipboard=unnamedplus " using the clipboard as default register

"" Use spaces instead of tabs
"set expandtab
"
"" Be smart when using tabs ;)
"set smarttab
"
"" 1 tab == 4 spaces
"set shiftwidth=4
"set tabstop=4
"set shiftwidth=4
set shiftwidth=4 autoindent smartindent tabstop=4 softtabstop=4 expandtab wrap
set backspace=indent,eol,start confirm

set splitbelow
set splitright

set nowritebackup
set nobackup
set nowb
set noswapfile

set nu
set rnu

set ignorecase
set smartcase
set hlsearch " Highlight search results

autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
command! W execute 'w !sudo tee % > /dev/null' <bar> edit! " (useful for handling the permission-denied error)  :W sudo saves the file 

"clean extra spaces on save
if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif

"source init after each save
autocmd! bufwritepost ~/.config/nvim/init.vim source ~/.config/nvim/init.vim

if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun


""status line
"set cmdheight=1
"set statusline=
"set statusline+=%#IncSearch#
"set statusline+=\ %y
"set statusline+=\ %r
"set statusline+=%#CursorLineNr#
"set statusline+=\ %F
"set statusline+=%= "Right side settings
"set statusline+=%#Search#
"set statusline+=\ %l/%L
"set statusline+=\ [%c]

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction 

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

func! DeleteTillSlash()
    let g:cmd = getcmdline()

    if has("win16") || has("win32")
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\]\\).*", "\\1", "")
    else
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
    endif

    if g:cmd == g:cmd_edited
        if has("win16") || has("win32")
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
        else
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
        endif
    endif   

    return g:cmd_edited
endfunc

func! CurrentFileDir(cmd)
    return a:cmd . " " . expand("%:p:h") . "/"
endfunc

"key-bindings
"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

let mapleader=","

" disable default bindings
nnoremap Q <nop>

" plugin bindings
nnoremap <leader><Space> :CtrlP<CR>
nnoremap <leader>g :Goyo<CR>
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark<Space>
map <leader>nf :NERDTreeFind<cr>

" splits
nnoremap <leader>sh :sf
nnoremap <leader>ss :vert ff 

" resize window
nnoremap <Up> :resize +2<CR> 
nnoremap <Down> :resize -2<CR>
nnoremap <Left> :vertical resize -2<CR>
nnoremap <Right> :vertical resize +2<CR>

" navigating windows
nnoremap <leader>h <C-W>h
nnoremap <leader>j <C-W>j
nnoremap <leader>k <C-W>k
nnoremap <leader>l <C-W>l
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" saving
nmap <leader>wq :wq<cr>
nmap <leader>ww :w<cr>
nmap <leader>ws :W<cr>

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>
map <silent> <leader><cr> :noh<cr>

" Close the current buffer
map <leader>bq :bd<cr>
" Close all the buffers
map <leader>ba :bufdo bd<cr>
map <leader>bl :bnext<cr>
map <leader>bh :bprevious<cr>
"show buffers
nmap <leader>bb :Buffers<cr>
" tab navigation
nnoremap tl :tabnext<CR>
nnoremap th :tabprev<CR>
nnoremap tf  :tabfind<Space>
nnoremap tq  :tabclose<CR>

" Move a line of text using leader+[-=]
nmap <Leader>- mz:m+<cr>`z
nmap <Leader>= mz:m-2<cr>`z
vmap <Leader>- :m'>+<cr>`<my`>mzgv`yo`z
vmap <Leader>= :m'<-2<cr>`>my`<mzgv`yo`z

" Quickly open a buffer for scribble
map <leader>q :e ~/Documents/.buffer<cr>
" Quickly open a markdown buffer for scribble
map <leader>x :e ~/Documents/.md-buffer.md<cr>
" Quickly load config
map <leader>e :e! ~/.config/nvim/init.vim<cr>
" Quick resourcing of the init
nnoremap <C-s> :source ~/.config/nvim/init.vim<CR>

" easier exit from insert mode
imap jk <esc>
"create shell buffer
nmap <leader>t :bo 15sp +te<cr>

map <leader>. :colo base16-
map <F1> :colorscheme darcula<CR>
map <F2> :colorscheme gruvbox<CR>
map <F3> :colorscheme base16-default-dark<CR>
map <F4> :colorscheme base16-ashes<CR>
map <F5> :colorscheme base16-onedark<CR>
map <F6> :colorscheme base16-tomorrow-night-eighties<CR>
map <F7> :colorscheme base16-paraiso<CR>
map <F8> :colorscheme base16-railscasts<CR>

" Smart mappings on the command line
cno $h e ~/
cno $d e ~/Documents/
cno $j e ~/Downloads/
cno $c e <C-\>eCurrentFileDir("e")<cr>

" it deletes everything until the last slash 
cno $/ <C-\>eDeleteTillSlash()<cr>

" abbreviations
iab xdt <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>
iab xdate <c-r>=strftime("%d/%m/%y")<cr>
iab xtime <c-r>=strftime("%H:%M:%S")<cr>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Gui
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set font according to system
if has("mac") || has("macunix")
    set gfn=IBM\ Plex\ Mono:h14,Hack:h14,Source\ Code\ Pro:h15,Menlo:h15
elseif has("win16") || has("win32")
    set gfn=IBM\ Plex\ Mono:h14,Source\ Code\ Pro:h12,Bitstream\ Vera\ Sans\ Mono:h11
elseif has("gui_gtk2")
    set gfn=IBM\ Plex\ Mono\ 14,:Hack\ 14,Source\ Code\ Pro\ 12,Bitstream\ Vera\ Sans\ Mono\ 11
elseif has("linux")
    set gfn=IBM\ Plex\ Mono\ 14,:Hack\ 14,Source\ Code\ Pro\ 12,Bitstream\ Vera\ Sans\ Mono\ 11
elseif has("unix")
    set gfn=Monospace\ 11
endif

" Disable scrollbars (real hackers don't use scrollbars for navigation!)
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L

"map <F5> :colorscheme spacegray<CR>
" TODO 04/08/20 11:23 > add more colorschemes

"Color Settings
colorscheme darcula
set background=dark cursorline termguicolors
"
"hi! Normal ctermbg=NONE guibg=NONE 
"hi! NonText ctermbg=NONE guibg=NONE guifg=NONE ctermfg=NONE 
hi Search guibg=wheat guifg=purple

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"File Types
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"python
au FileType python set colorcolumn=80
au FileType python iab todo # TODO <c-r>=strftime("%d/%m/%y %H:%M")<cr> >
let g:mkdp_browser = 'midori'

"vim
au FileType vim iab todo " TODO <c-r>=strftime("%d/%m/%y %H:%M")<cr> >

iab xjtodo // TODO <c-r>=strftime("%d/%m/%y")<cr> >

