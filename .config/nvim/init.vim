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
    set nocursorline
    CocDisable
    Limelight
endfunction

function! s:goyo_leave()
    set showmode
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
set nocompatible

set incsearch " Incremental search view
set magic " behaviour of slash in patterns
set ignorecase " case sensitivity
set smartcase " no ignorecase when using upper case in search pattern

set wrap " wrap long lines
set showbreak=⤥\ \ 
set so=7 " Set 7 lines to the cursor - when moving vertically using j/k
set nu " Show line numbers
set rnu " Show relative line numbers
set lbr "enable linebreak after 'tw' characters

set background=dark " the background color brightness
syntax enable
set termguicolors " use GUI colors for the terminal
set cursorline "highlight the line of the cursor
set hlsearch " Highlight search results

set laststatus=2
set hidden " Sets buffers are hidden instead of closed when moved from set autoread " Set to auto read when a file is changed from the outside
set splitbelow splitright " split directions

set mouse=a " enable mouse in all modes

set showcmd " show partial commands on statusline
set ruler "Always show current position
set confirm " start a dialog when a command fails

set clipboard=unnamedplus " using the clipboard as default register
 
set backspace=indent,eol,start " backspace behaviour
set tw=500 " number of characters per line (in which it breaks)

set smarttab autoindent smartindent expandtab  " <tab> behaviour
set shiftwidth=4 tabstop=8 softtabstop=4 " <tab> widths

set writebackup " backup before writing
set nobackup " don't backup after writing
set ffs=unix,dos,mac " Use Unix as the standard file type

" TODO 08/08/20 13:55 > define folding

set history=500 " Sets how many lines of history VIM has to remember
set wildmenu " Turn on the Wild menu
set wildignore=*.o,*~,*.pyc " Ignore compiled files

set encoding=UTF-8 " encoding you know

" commands and functions
"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

filetype plugin indent on

autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
command! W execute 'w !sudo tee % > /dev/null' <bar> edit! " (useful for handling the permission-denied error)  :W sudo saves the file 

"clean extra spaces on save
if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif

"source init after each save
autocmd! bufwritepost ~/.config/nvim/init.vim source ~/.config/nvim/init.vim

" add wildignores based on system
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

" overwrite DiffOrig to show syntax-highlighting (by forcing filetype)
command! -bar DiffOrig
    \   vnew +set\ buftype=nofile
    \ | let &filetype = getbufvar(0, '&filetype')
    \ | read ++edit #
    \ | 1delete_
    \ | diffthis
    \ | wincmd p
    \ | diffthis

" restore cursor position
autocmd BufReadPost 
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif

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

" helper for visualselection
function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction 

" handle visual selection search operations
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

" delete until a slash in cmd
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
nnoremap <leader>ss :vert sf 

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
" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>
" turn off highlight-searching
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

"Color Settings
colorscheme darcula
"
"hi! Normal ctermbg=NONE guibg=NONE 
"hi! NonText ctermbg=NONE guibg=NONE guifg=NONE  ctermfg=NONE 
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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Credits
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" this rc was built over a long period of time so I obviously borrowed parts of many other rc's
" I did not collect all of them but among them the ones that stand out more are
" Amir Salihefendic's:  https://github.com/amix/vimrc
" Nick Nisi's https://github.com/nicknisi/vim-workshop/blob/master/vimrc
" My own prefferations, and some minor picks from here and there...
