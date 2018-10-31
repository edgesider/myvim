func! SetWin32Gui()
    set encoding=utf8
    set fileencoding=utf8
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
    set lines=30 columns=100
    set guioptions-=m
    set guioptions-=T
    set guioptions-=e
    set guioptions-=r
    set guioptions-=L
    set guioptions+=!
    set guioptions+=c
    set guifont=consolas:h14
    set guifontwide=黑体
    " 将所有的光标设置为白块不闪烁，然后单独设置visual模式的光标
    set guicursor=a:block-iCursor-blinkon0,v:block-vCursor
    set pythonthreedll=python36.dll
endfunc

func! SaveSpace()
py3 << EOF
import vim
import os
if not os.path.isdir(".vimws"):
    os.mkdir(".vimws")
vim.command("mksession! .vimws/session")
vim.command("wviminfo! .vimws/info")
vim.command('echo "workspace saved"')
EOF
endfunc

func! LoadSpace()
    if filereadable(".vimws/session")
        source .vimws/session
        cd ..
    else
        echo "session file don't exist"
    endif
    if filereadable(".vimws/info")
        rviminfo .vimws/info
    else
        echo "info file don't exist"
    endif
endfunc

" 编译或运行
func! RunOrCompile()
    if &filetype == 'c'
        exec "w"
        exec "!gcc % -o %<"
        exec "!./%<"
    elseif &filetype == 'cpp'
        exec "w"
        exec "!g++ % -std=c++11 -o %<"
        exec "!./%<"
    elseif &filetype == 'python'
        exec "w"
        exec "!python %"
    elseif &filetype == 'perl'
        exec "w"
        exec "!perl %"
    elseif &filetype == 'sh'
        exec "w"
        exec "!bash %"
    elseif &filetype == 'go'
        exec "w"
        exec "!go run %"
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
            and not os.path.isfile(os.path.join(pack, 'doc', "tags")):
            vim.command('helptags {}'.format(os.path.join(pack, 'doc')))
    os.chdir(current_dir)

packpath_list = vim.eval('&packpath').split(',')

gen_doc_from_pack_folder(packpath_list[0])
EOF
endfunc

if has('win32') && has('gui_running')
    call SetWin32Gui()
endif

if !has('win32')
    set shell=/bin/bash
endif

"packadd! ycm
packadd! tagbar
packadd! nerdtree
packadd! molokai
packadd! vim-surround
packadd! jedi-vim
packadd! indentLine     " 对齐线"
packadd! ultisnips      " snippet"
packadd! vim-snippets   " 常用snippet"
packadd! delimitMate    " 括号、引号补全"
packadd! nerdcommenter  " 注释"

if has('win32') && has('gui_running')
    packadd! vim-powerline
else
    packadd! vim-airline " there are some bugs of airline on win32
    packadd! fcitx.vim
endif

set sessionoptions-=curdir
set sessionoptions+=sesdir
set sessionoptions-=blank
set sessionoptions+=winpos
set sessionoptions+=resize
set sessionoptions+=winsize
set sessionoptions+=unix
set sessionoptions+=slash
nnoremap <silent> <C-F9> :call SaveSpace()<CR>
nnoremap <silent> <C-F10> :call LoadSpace()<CR>

colorscheme molokai
"自动补全
filetype plugin indent on
set completeopt=preview,menu
setlocal cm=blowfish2  " 设置加密方式
set autoread
set number
set shiftwidth=4  "操作（<<和>>）时缩进的列数
set ts=4    "tabstop 一个tab键所占的列数
set expandtab   "输入tab时自动将其转化为空格
set nowrap " 禁止折行
set laststatus=2 " 显示光标当前位置
set number
set cursorline cursorcolumn " 高亮显示当前行/列
set hlsearch " 高亮显示搜索结果
set incsearch " 实时搜索
set nocompatible " 关闭兼容模式
set showcmd    " 右下角按键显示
set autowrite " 自动保存
set ignorecase  " 忽略大小写
set smartindent
set foldmethod=indent " 折叠方式
" set foldcolumn=2    " 折叠层次显示
" set foldlevelstart=99
set colorcolumn=100  " 80个字符处划线
" set fillchars=vert:\   " 将分割线设置为空格，末尾有空格，需要转义
set wildmenu wildmode=longest,full" Ex模式下Tab键补全窗口
set clipboard=unnamed
set completeopt=longest,menu
set ttimeoutlen=-1 " 退出编辑模式不等待

syntax enable " 开启语法高亮功能
syntax on " 允许用指定语法高亮配色方案替换默认方案

" 一些键盘映射
let mapleader=" " "自定义前缀键
let localleader=" " "自定义前缀键
nnoremap <silent> <leader>l :nohlsearch<CR>

nnoremap <C-S> :w<CR>
nnoremap <silent> <F5> :call RunOrCompile()<CR>
nnoremap <M-j> jzz
nnoremap <M-k> kzz

" 窗口切换
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" buffer切换
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>

" 标签页切换
nnoremap <silent> [t :tabprevious<CR>
nnoremap <silent> ]t :tabnext<CR>

" quickfix
noremap <silent> ]q :cnext<CR>
noremap <silent> [q :cprevious<CR>

" ycm
nnoremap <silent> ygd :YcmCompleter GoTo<CR>

" command mode key bindings
cnoremap <C-A> <Home>
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>
cnoremap <M-B> <S-Left>
cnoremap <M-F> <S-Right>

nnoremap <silent> <leader>t :TagbarToggle<CR>
let g:tagbar_width = 30
let g:tagbar_left = 1
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

nnoremap <leader>n :NERDTreeToggle<CR>
" NERDTree窗口放到右边
let NERDTreeWinPos=1
" 只剩下一个NERDTree窗口时，关闭vim
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

let g:jedi#force_py_version = 3
let g:jedi#popup_on_dot=0

if has('win32') && has('gui_running')
    let g:ycm_global_ycm_extra_conf='C:\Users\Administrator\vimfiles\pack\plugins\opt\ycm\.ycm_extra_conf.py'
else
    let g:ycm_global_ycm_extra_conf='~/.vim/pack/plugins/opt/ycm/.ycm_extra_conf.py'
endif
let g:ycm_key_list_select_compeletion = ['<c-n>']
let g:ycm_key_list_previous_compeletion = ['<c-p>']
let g:ycm_filetype_whitelist = {
            \ "c": 1,
            \ "cpp": 1,
            \ "objc": 1,
            \ "sh": 1,
            \ "js": 1,
            \ "go": 1,
            \}

let g:UltiSnipsExpandTrigger="<c-j>"  " ultisnip snip扩展快捷键"
let g:UltiSnipsEditSplit="vertical"   " ultisnip 编辑模式横向窗口打开"

autocmd Filetype json let g:indentLine_enabled = 0

call GenDoc()
