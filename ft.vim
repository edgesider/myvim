autocmd FileType markdown
            \ set wrap
            \ | set nolinebreak
            \ | set showbreak=-
            \ | nnoremap <buffer> j gj
            \ | nnoremap <buffer> k gk
autocmd FileType asm :set filetype=nasm
autocmd Filetype json let g:indentLine_enabled = 0
autocmd Filetype help if &buftype == 'help' | nnoremap <buffer> q :q<cr> | endif
