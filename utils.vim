func! TrimRight()
    try
        %s/\s\+$//
        norm! ``
    catch
    endtry
endfunc

func! TabToSpace()
    let space = " "->repeat(&tabstop)
    let cmd = "%s/\t/" . space . "/g"
    try
        execute cmd
        norm! ``
    catch
    endtry
endfunc

" 状态保存相关
func! SetupStateSave()
    " 备份文件
    set backupdir=~/.cache/vim/bak
    call mkdir(&backupdir, 'p')
    set backup

    " undo文件
    set undolevels=200
    set undodir=~/.cache/vim/undo
    call mkdir(&undodir, 'p')
    set undofile

    " *Copied from $VIMRUNTIME/defaults.vim*
    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid, when inside an event handler
    " (happens when dropping a file on gvim) and for a commit message (it's
    " likely a different one than last time).
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif
endfunc

func! SetGui()
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
    set guioptions-=m
    set guioptions-=T
    set guioptions-=e
    set guioptions-=r
    set guioptions-=L
    set guioptions+=!
    set guioptions+=c
    " 将所有的光标设置为白块不闪烁，然后单独设置visual模式的光标
    set guicursor=a:block-Cursor-blinkon0,v:block-Cursor
    set backspace=indent,eol,start   " 任何时候都可以使用退格键
endfunc

func! SetWin32()
    set encoding=utf8
    set fileencoding=utf8
    set lines=30 columns=100
    set guifont=consolas:h14
    set guifontwide=黑体
    set pythonthreedll=python36.dll
endfunc

func! SetGtkGUI()
    set guifont=Source\ Code\ Pro\ Medium\ 15
    set guifontwide=黑体
endfunc

 " 查看模式保持光标在中间
func! LookingMap()
    try
        nnoremap <buffer> j jzz
        nnoremap <buffer> k kzz
        nnoremap <buffer> G Gzz
        nnoremap <buffer> <c-e> jzz
        nnoremap <buffer> <c-y> kzz
        nnoremap <buffer> <c-d> <c-d>zz
        nnoremap <buffer> <c-u> <c-u>zz
        nnoremap <buffer> * *zz
        nnoremap <buffer> # #zz
        nnoremap <buffer> <Down> <Down>zz
        nnoremap <buffer> <Up> <Up>zz
        vnoremap <buffer> j jzz
        vnoremap <buffer> k kzz
        vnoremap <buffer> G Gzz
        vnoremap <buffer> <c-e> jzz
        vnoremap <buffer> <c-y> kzz
        vnoremap <buffer> <c-d> <c-d>zz
        vnoremap <buffer> <c-u> <c-u>zz
        vnoremap <buffer> * *zz
        vnoremap <buffer> # #zz
        vnoremap <buffer> <Down> <Down>zz
        vnoremap <buffer> <Up> <Up>zz
    endtry
    set colorcolumn=0
endfunc
func! NonLookingMap()
    try
        nunmap <buffer> j
        nunmap <buffer> k
        nunmap <buffer> G
        nunmap <buffer> <c-e>
        nunmap <buffer> <c-y>
        nunmap <buffer> <c-d>
        nunmap <buffer> <c-u>
        nunmap <buffer> *
        nunmap <buffer> #
        nunmap <buffer> <down>
        nunmap <buffer> <up>
        vunmap <buffer> j
        vunmap <buffer> k
        vunmap <buffer> G
        vunmap <buffer> <c-e>
        vunmap <buffer> <c-y>
        vunmap <buffer> <c-d>
        vunmap <buffer> <c-u>
        vunmap <buffer> *
        vunmap <buffer> #
        vunmap <buffer> <down>
        vunmap <buffer> <up>
    endtry
    set colorcolumn=100
endfunc

" 设置keycode以支持终端中map alt键
function! Terminal_MetaMode(mode)
    set ttimeout
    if $TMUX != ''
        set ttimeoutlen=30
    elseif &ttimeoutlen > 80 || &ttimeoutlen <= 0
        set ttimeoutlen=80
    endif
    if has('nvim') || has('gui_running')
        return
    endif
    function! s:metacode(mode, key)
        if a:mode == 0
            exec "set <M-".a:key.">=\e".a:key
        else
            exec "set <M-".a:key.">=\e]{0}".a:key."~"
        endif
    endfunc
    for i in range(10)
        call s:metacode(a:mode, nr2char(char2nr('0') + i))
    endfor
    for i in range(26)
        call s:metacode(a:mode, nr2char(char2nr('a') + i))
        "call s:metacode(a:mode, nr2char(char2nr('A') + i))
    endfor
    if a:mode != 0
        for c in [',', '.', '/', ';', '[', ']', '{', '}']
            call s:metacode(a:mode, c)
        endfor
        for c in ['?', ':', '-', '_']
            call s:metacode(a:mode, c)
        endfor
    else
        for c in [',', '.', '/', ';', '{', '}']
            call s:metacode(a:mode, c)
        endfor
        for c in ['?', ':', '-', '_']
            call s:metacode(a:mode, c)
        endfor
    endif
endfunc

func! GenDoc()
py3 << EOF
import vim
import os

def gen_doc_from_pack_folder(folder):
    pack_path = os.path.join(folder, 'pack', 'plugins', 'opt')
    current_dir = os.getcwd()
    os.chdir(pack_path)

    for pack in os.listdir(pack_path):
        if os.path.isdir(os.path.join(pack, 'doc')) \
            and not os.path.isfile(os.path.join(pack, 'doc', 'tags')):
            vim.command('helptags {}'.format(os.path.join(pack, 'doc')))
    os.chdir(current_dir)

packpath_list = vim.eval('&packpath').split(',')

gen_doc_from_pack_folder(packpath_list[0])
EOF
endfunc

func! DiffOrig() abort
    vert new
    set bt=nofile
    r ++edit #
    0d_
    diffthis
    wincmd p
    diffthis
    wincmd p
    nnoremap <buffer> q :q<cr>
endfunc
