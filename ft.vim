autocmd FileType markdown
            \ setlocal wrap
            \ | set nolinebreak
            \ | set showbreak=-
            " \ | nnoremap <buffer> j gj
            " \ | nnoremap <buffer> k gk
autocmd FileType asm set filetype=nasm
autocmd FileType json let g:indentLine_enabled = 0
autocmd FileType help if &buftype == 'help' | nnoremap <buffer> q :q<cr> | endif
autocmd FileType fish set shiftwidth=2 | set tabstop=4
autocmd FileType typescript,javascript,proto set shiftwidth=2
autocmd BufNewFile,BufRead * if expand('%:t') == '.xprofile' | set ft=bash | endif
autocmd BufNewFile,BufRead * if expand('%:p') =~ '.*waybar/config' | set ft=json5 | endif

autocmd BufEnter *.slint :setlocal ft=slint
