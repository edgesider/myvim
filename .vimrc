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
command TabToSpace call TabToSpace()

autocmd BufWritePre * call TrimRight()

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
command Imlooking call LookingMap()
command Imwriting call NonLookingMap()

func! FTMarkDown()
    set wrap
    set nolinebreak
    set showbreak=-
    nnoremap <buffer> j gj
    nnoremap <buffer> k gk
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
        call s:metacode(a:mode, nr2char(char2nr('A') + i))
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

call Terminal_MetaMode(0)

func! SaveSpace()
py3 << EOF
import vim
import os
if not os.path.isdir('.vimws'):
    os.mkdir('.vimws')
if os.path.isfile('.vimws/session'):
    os.rename('.vimws/session', '.vimws/last_session')
if os.path.isfile('.vimws/info'):
    os.rename('.vimws/info', '.vimws/last_info')
vim.command('mksession! .vimws/session')
vim.command('wviminfo! .vimws/info')
vim.command("echo 'workspace saved'")
EOF
endfunc

func! LoadSpace()
    if filereadable('.vimws/session')
        source .vimws/session
        cd ..
    else
        echo 'session file not exist'
    endif
    if filereadable('.vimws/info')
        rviminfo .vimws/info
    else
        echo 'info file not exist'
    endif
endfunc

func! LoadLastSpace()
    if filereadable('.vimws/session')
        source .vimws/last_session
        cd ..
    else
        echo 'last session file not exist'
    endif
    if filereadable('.vimws/last_info')
        rviminfo .vimws/last_info
    else
        echo 'last info file not exist'
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
command! Gendoc call GenDoc()

packadd! vim-surround
packadd! ultisnips      " snippet
packadd! my-snippets    " 常用snippet
packadd! delimitMate    " 括号、引号补全
packadd! nerdcommenter  " 注释
packadd! vim-airline
packadd! LeaderF
packadd! easymotion
packadd! f5run
packadd! vimtex
" packadd! gen_tags
" 语法高亮
packadd! python-syntax
packadd! plantuml-syntax
packadd! haskell-vim
packadd! c-syntax.vim
packadd! vim-fish
packadd! coc.nvim

set sessionoptions-=curdir
set sessionoptions+=sesdir
set sessionoptions-=blank
set sessionoptions+=winpos
set sessionoptions+=resize
set sessionoptions+=winsize
set sessionoptions+=unix
set sessionoptions+=slash
nnoremap <silent> <c-f9> :call SaveSpace()<cr>
nnoremap <silent> <c-f10> :call LoadSpace()<cr>

" let g:PaperColor_Theme_Options = {
"   \   'language': {
"   \     'python': {
"   \       'highlight_builtins' : 1
"   \     },
"   \     'cpp': {
"   \       'highlight_standard_library': 1
"   \     },
"   \     'c': {
"   \       'highlight_builtins' : 1
"   \     }
"   \   }
"   \ }
" set background=dark
" colorscheme PaperColor
colorscheme jellybeans

"自动补全
filetype plugin indent on
setlocal cryptmethod=blowfish2  " 设置加密方式
set autoread
set number
set shiftwidth=4  "操作（<<和>>）时缩进的列数
set tabstop=4    "tabstop 一个tab键所占的列数
set expandtab   "输入tab时自动将其转化为空格
set nowrap " 禁止折行
set laststatus=2 " 显示光标当前位置
set number
set cursorline cursorcolumn " 高亮显示当前行/列
set hlsearch " 高亮显示搜索结果
set incsearch " 实时搜索
set showcmd    " 右下角按键显示
set autowrite " 自动保存
set ignorecase  " 忽略大小写
set smartindent
set foldmethod=indent " 折叠方式
" set foldcolumn=2    ' 折叠层次显示
set foldlevelstart=100 " 默认不折叠
set colorcolumn=100  " 100个字符处划线
" set fillchars=vert:\   ' 将分割线设置为空格，末尾有空格，需要转义
set wildmenu wildmode=longest,full " Ex模式下Tab键补全窗口
set clipboard=unnamed
set completeopt=longest,menu,noselect
set mouse=a
set ttymouse=xterm2
set backspace=indent,eol,start
set noshowcmd

syntax enable " 开启语法高亮功能
syntax on " 允许用指定语法高亮配色方案替换默认方案

" 键盘映射
let mapleader=' ' "自定义前缀键
let localleader=' ' "自定义前缀键
nnoremap <silent> <leader>l :nohlsearch<cr>

nnoremap <silent> <leader>T :terminal fish<cr>

" leaderF
command Lf command LeaderF
nnoremap <silent> <leader>m :Leaderf! mru<cr>
nnoremap <silent> <leader>f :Leaderf! file<cr>
nnoremap <silent> <leader>g :Leaderf! gtags<cr>
nnoremap <silent> <leader>w :Leaderf! window<cr>
nnoremap <silent> <leader>q :Leaderf! quickfix<cr>

nnoremap <c-s> :w<cr>
nnoremap <silent> <f5> :call f5#Run()<cr>
tnoremap <silent> <c-w><f5> <c-w>:call f5#Run()<cr>

" 窗口切换
nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
nnoremap <c-l> <c-w><c-l>
nnoremap <c-h> <c-w><c-h>

" buffer切换
nnoremap <silent> [b :bprevious<cr>
nnoremap <silent> ]b :bnext<cr>
tnoremap <silent> <c-w>[b <c-w>:bprevious<cr>
tnoremap <silent> <c-w>]b <c-w>:bnext<cr>

" 标签页切换
nnoremap <silent> \t :tabnew .<cr>
nnoremap <silent> [t :tabprevious<cr>
nnoremap <silent> ]t :tabnext<cr>
tnoremap <silent> <c-w>[t <c-w>:tabprevious<cr>
tnoremap <silent> <c-w>]t <c-w>:tabnext<cr>

" quickfix
noremap <silent> \q :copen<cr>
noremap <silent> ]q :cnext<cr>
noremap <silent> [q :cprevious<cr>

" copy
vnoremap <c-c> "+y
nnoremap <c-c> "+yy

" coc
nmap gd <plug>(coc-definition)
nmap gD <plug>(coc-declaration)
nmap gi <plug>(coc-implementation)
nmap gu <plug>(coc-references)
nmap <leader>r <plug>(coc-rename)
nmap <leader>; :CocFix<cr>
" nmap <leader>l <plug>(coc-format)
nmap ]c <plug>(coc-diagnostic-next)
nmap [c <plug>(coc-diagnostic-prev)
nmap ]e <plug>(coc-diagnostic-next-error)
nmap [e <plug>(coc-diagnostic-prev-error)
nmap \c :CocList diagnostics<cr>
nmap \o :CocList outline<cr>
nmap <leader>e :CocCommand explorer<CR>

command! -nargs=0 Fmt :call CocAction('format')
autocmd CursorHold * silent call CocActionAsync('highlight')

" easy-align
" xmap ga <plug>(EasyAlign)
" nmap ga <plug>(EasyAlign)

" easy-motion
" map <leader><leader>l <plug>(easymotion-lineforward)
" map <leader><leader>j <plug>(easymotion-j)
" map <leader><leader>k <plug>(easymotion-k)
" map <leader><leader>h <plug>(easymotion-linebackward)

" command mode key bindings
cnoremap <c-a> <home>
cnoremap <c-e> <end>
cnoremap <c-f> <right>
cnoremap <c-b> <left>
cnoremap <m-f> <c-right>
cnoremap <m-b> <c-left>

inoremap <c-a> <home>
inoremap <c-e> <end>
inoremap <c-f> <right>
inoremap <c-b> <left>
inoremap <m-f> <c-right>
inoremap <m-b> <c-left>
inoremap <c-j> <c-x><c-o>

" unmap unused bind
"inoremap <c-@> <esc>

let g:f5#cmds = {
            \ 'c': 'gcc % -g -o %< -Wall && ./%<'
            \ }

"let g:jedi#force_py_version = '3.8'
let g:jedi#popup_on_dot=0

let g:UltiSnipsExpandTrigger='<c-j>'  " ultisnip snip扩展快捷键
let g:UltiSnipsEditSplit='vertical'   " ultisnip 编辑模式横向窗口打开

let g:Lf_WindowHeight = 0.3
let g:Lf_PreviewResult = {
        \ 'File': 0,
        \ 'Buffer': 0,
        \ 'Mru': 0,
        \ 'Tag': 0,
        \ 'BufTag': 0,
        \ 'Function': 0,
        \ 'Line': 0,
        \ 'Colorscheme': 0
        \}

"let g:vimtex_quickfix_mode = 0
let g:vimtex_compiler_latexmk = {'build_dir' : 'dist'}
let g:vimtex_compiler_latexmk_engines = {'_': '-xelatex'}

autocmd Filetype json let g:indentLine_enabled = 0

let g:EasyMotion_smartcase = 1

let g:airline#extensions#coc#enabled = 1

" call GenDoc()

if !has('win32')
    set shell=/bin/bash
    set fileencodings=ucs-bom,utf-8,cp936,default,latin1
endif
scriptencoding utf8

if has('gui_running')
    call SetGui()

    if has('win32') && has('gui_running')
        call SetWin32()
    endif

    if has('gui_gtk')
        call SetGtkGUI()
    endif
endif

autocmd FileType markdown call FTMarkDown()
autocmd FileType asm :set filetype=nasm
