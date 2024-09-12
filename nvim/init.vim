" call SetupStateSave()
" call Terminal_MetaMode(0)
" call theme#Sonokai()

" 自动补全
filetype plugin indent on
syntax enable " 开启语法高亮功能
syntax on " 允许用指定语法高亮配色方案替换默认方案
set number
set shiftwidth=4  "操作（<<和>>）时缩进的列数
set tabstop=4    "tabstop 一个tab键所占的列数
set expandtab   "输入tab时自动将其转化为空格
set nowrap " 禁止折行
set laststatus=2 " 显示光标当前位置
set number
set cursorcolumn " 高亮显示当前行/列
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
set wildmenu wildmode=longest,full " Ex模式下Tab键补全窗口
set clipboard=unnamed
" set completeopt=longest,menu
set mouse=a
" set ttymouse=sgr
set backspace=indent,eol,start
set noshowcmd
set title
set scrolloff=5
set updatetime=1000
set signcolumn=yes

command! Wq wq
scriptencoding utf8

" 键盘映射 {{{
let mapleader=' ' "自定义前缀键
let localleader=' ' "自定义前缀键
" nnoremap <silent> <leader>l :nohlsearch<cr>
nnoremap <silent> <esc> :nohlsearch<cr>
" nnoremap <silent> <leader>T :terminal fish<cr>

" leaderF
" nnoremap <silent> <leader>m :Leaderf mru<cr>
" nnoremap <silent> <leader>f :Leaderf file<cr>
" nnoremap <silent> <leader>g :Leaderf gtags<cr>
" nnoremap <silent> <leader>w :Leaderf window<cr>
" nnoremap <silent> <leader>q :Leaderf quickfix<cr>

" nnoremap <c-s> :w<cr>
" nnoremap <silent> <f5> :call f5#Run()<cr>
" nnoremap <silent> <f4> :call f5#Run()<cr>
" tnoremap <silent> <c-w><f5> <c-w>:call f5#Run()<cr>

" 窗口切换
" nnoremap <c-j> <c-w><c-j>
" nnoremap <c-k> <c-w><c-k>
" nnoremap <c-l> <c-w><c-l>
" nnoremap <c-h> <c-w><c-h>

" buffer切换
" nnoremap <silent> [b :bprevious<cr>
" nnoremap <silent> ]b :bnext<cr>
" tnoremap <silent> <c-w>[b <c-w>:bprevious<cr>
" tnoremap <silent> <c-w>]b <c-w>:bnext<cr>

" 标签页切换
nnoremap <silent> \t :tabnew .<cr>
nnoremap <silent> [t :tabprevious<cr>
nnoremap <silent> ]t :tabnext<cr>
tnoremap <silent> <c-w>[t <c-w>:tabprevious<cr>
tnoremap <silent> <c-w>]t <c-w>:tabnext<cr>

" quickfix
" noremap <silent> \q :copen<cr>
" noremap <silent> ]q :cnext<cr>
" noremap <silent> [q :cprevious<cr>

" copy
" if $XDG_SESSION_TYPE == "wayland"
"     vnoremap <silent> <c-c> "+y:call system('wl-copy', @+)<cr>
"     nnoremap <silent> <c-c> "+yy:call system('wl-copy', @+)<cr>
" else
"     vnoremap <c-c> "+y
"     nnoremap <c-c> "+yy
" endif

" search in visual mode
vnoremap // y/\v<c-r>=escape(@",'/\')<cr><cr>

" command mode key bindings
cnoremap <c-a> <home>
cnoremap <c-e> <end>
cnoremap <c-f> <right>
cnoremap <c-b> <left>
cnoremap <m-f> <c-right>
cnoremap <m-b> <c-left>
cnoremap <m-right> <c-right>
cnoremap <m-left> <c-left>

inoremap <c-a> <home>
inoremap <c-e> <end>
inoremap <c-f> <right>
inoremap <c-b> <left>
inoremap <m-f> <c-right>
inoremap <m-b> <c-left>
inoremap <m-right> <c-right>
inoremap <m-left> <c-left>

" unmap unused bind
"inoremap <c-@> <esc>
" }}}

if exists('g:vscode')
    nnoremap <silent> j :call VSCodeCall('cursorDown')<cr>
    nnoremap <silent> k :call VSCodeCall('cursorUp')<cr>
    nnoremap <silent> zc :call VSCodeCall('editor.fold')<cr>
    nnoremap <silent> zo :call VSCodeCall('editor.unfold')<cr>
    nnoremap <silent> zC :call VSCodeCall('editor.foldRecursively')<cr>
    nnoremap <silent> zO :call VSCodeCall('editor.unfoldRecursively')<cr>
    nmap <silent> zx zCzo
endif
