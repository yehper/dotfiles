"    _____ __  ______
"   / __(_) /_/_  __/_ _____  ___
"  / _// / / -_) / / // / _ \/ -_)
" /_/ /_/_/\__/_/  \_, / .__/\__/
"                 /___/_/
"   _____          ____                    __  _
"  / ___/__  ___  / _(_)__ ___ _________ _/ /_(_)__  ___
" / /__/ _ \/ _ \/ _/ / _ `/ // / __/ _ `/ __/ / _ \/ _ \
" \___/\___/_//_/_//_/\_, /\_,_/_/  \_,_/\__/_/\___/_//_/
"                    /___/

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Python
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au FileType python set colorcolumn=80
au FileType python iab todo # TODO <c-r>=strftime("%d/%m/%y %H:%M")<cr> >

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au FileType vim iab todo " TODO <c-r>=strftime("%d/%m/%y %H:%M")<cr> >

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" bash
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" start with a skeleton
if has("autocmd")
  augroup templates
    autocmd BufNewFile *.sh 0r ~/.config/nvim/templates/skeleton.sh
  augroup END
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" markdown
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" start with a skeleton
"if has("autocmd")
  "augroup templates
    "autocmd BufNewFile *.md 0r ~/.config/nvim/templates/skeleton.md
  "augroup END
"endif

" spelling on
if has("autocmd")
  augroup templates
   au BufNewFile,BufRead *.md setlocal spell spelllang=en_us
   au BufNewFile,BufRead *.txt setlocal spell spelllang=en_us
  augroup END
endif
