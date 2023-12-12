source ~/.vim/utils.vim
source ~/.vim/space.vim
source ~/.vim/theme.vim
source ~/.vim/ft.vim
source ~/.vim/gui.vim

let g:plugins = {
            \ 'surround': 1,
            \ 'ultisnips': 1,
            \ 'my-snippets': 1,
            \ 'delimitMate': 1,
            \ 'nerdcommenter': 1,
            \ 'airline': 1,
            \ 'LeaderF': 1,
            \ 'f5run': 1,
            \ 'vimtex': 1,
            \ 'coc': 1,
            \ }

func! g:PluginEnabled(name)
    if &loadplugins == 0
        return 0
    endif
    return has_key(g:plugins, a:name)
endf

for [name, enabled] in items(g:plugins)
    if enabled
        exec 'packadd! ' .. name
    endif
endfor

call SetupStateSave()
call Terminal_MetaMode(0)
call theme#Sonokai()

" 自动补全
filetype plugin indent on
syntax enable " 开启语法高亮功能
syntax on " 允许用指定语法高亮配色方案替换默认方案
set cryptmethod=blowfish2  " 设置加密方式
set autoread
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
set ttymouse=sgr
set backspace=indent,eol,start
set noshowcmd
set title
set scrolloff=5
set updatetime=1000

autocmd BufNewFile,BufRead *.ll set ft=llvm
autocmd BufWritePre * call TrimRight()
command TabToSpace call TabToSpace()
command Imlooking call LookingMap()
command Imwriting call NonLookingMap()
command Gendoc call GenDoc()
command DiffOrig call DiffOrig() " *Copied from $VIMRUNTIME/defaults.vim*
command Wq wq

" Plugin settings {{{
let NERDSpaceDelims = 1
let g:f5#cmds = {
            \ 'c': 'gcc % -g -o %< -Wall && ./%<'
            \}

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

let g:airline#extensions#coc#enabled = 1

let g:NERDCustomDelimiters = {
      \ 'python': { 'left': '#', 'right': '' }
      \ }

if !has('win32')
    set shell=/bin/bash
    set fileencodings=ucs-bom,utf-8,cp936,default,latin1
endif
scriptencoding utf8
" }}}

" 键盘映射 {{{
let mapleader=' ' "自定义前缀键
let localleader=' ' "自定义前缀键
" nnoremap <silent> <leader>l :nohlsearch<cr>
nnoremap <silent> <esc> :nohlsearch<cr><esc>
nnoremap <silent> <leader>T :terminal fish<cr>

" leaderF
nnoremap <silent> <leader>m :Leaderf mru<cr>
nnoremap <silent> <leader>f :Leaderf file<cr>
nnoremap <silent> <leader>g :Leaderf gtags<cr>
nnoremap <silent> <leader>w :Leaderf window<cr>
nnoremap <silent> <leader>q :Leaderf quickfix<cr>

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
if $XDG_SESSION_TYPE == "wayland"
    vnoremap <silent> <c-c> "+y:call system('wl-copy', @+)<cr>
    nnoremap <silent> <c-c> "+yy:call system('wl-copy', @+)<cr>
else
    vnoremap <c-c> "+y
    nnoremap <c-c> "+yy
endif

" search in visual mode
vnoremap // y/\v<c-r>=escape(@",'/\')<cr><cr>

if PluginEnabled('coc')
    " coc
    nmap <c-]> <plug>(coc-definition)
    nmap gd <plug>(coc-definition)
    nmap gD <plug>(coc-declaration)
    nmap gi <plug>(coc-implementation)
    nmap gu <plug>(coc-references)
    nmap <leader>r <plug>(coc-rename)
    nmap <leader>; <plug>(coc-fix-current)
    nmap <leader>' <plug>(coc-codeaction-selected)<cr>
    nmap <leader>p :CocList command<cr>
    nmap <silent> <leader>l <plug>(coc-format)
    nmap <leader><leader>l :echo 'nop'<cr>
    nmap ]c <plug>(coc-diagnostic-next)
    nmap [c <plug>(coc-diagnostic-prev)
    nmap ]e <plug>(coc-diagnostic-next-error)
    nmap [e <plug>(coc-diagnostic-prev-error)
    nmap \c :CocList diagnostics<cr>
    nmap \o :CocList outline<cr>
    nmap \e :CocCommand explorer<CR>
    autocmd CursorHold * silent call CocActionAsync('highlight')

    function! CheckBackspace() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1] =~# '\s'
    endfunction

    " Tab/S-Tab for completion
    " inoremap <silent><expr> <tab>
          " \ coc#pum#visible() ? coc#pum#next(1) :
          " \ CheckBackspace() ? "\<tab>" :
          " \ coc#refresh()
    " inoremap <expr><s-tab> coc#pum#visible() ? coc#pum#prev(1) : "\<c-h>"
    inoremap <expr> <tab> coc#pum#visible() ? coc#pum#confirm() : "<tab>"
    inoremap <m-p> <c-\><c-o>:call CocActionAsync('showSignatureHelp')<cr>

    function! ShowDocumentation()
      if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
      else
        call feedkeys('K', 'in')
      endif
    endfunction

    nnoremap <silent> K :call ShowDocumentation()<cr>

    nnoremap <nowait><expr> <m-j> coc#float#has_scroll() ? coc#float#scroll(1,1) : ""
    nnoremap <nowait><expr> <m-k> coc#float#has_scroll() ? coc#float#scroll(0,1) : ""
    inoremap <nowait><expr> <m-j> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1,1)\<cr>" : ""
    inoremap <nowait><expr> <m-k> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0,1)\<cr>" : ""

    " text objects
    xmap if <Plug>(coc-funcobj-i)
    omap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap af <Plug>(coc-funcobj-a)
    xmap ic <Plug>(coc-classobj-i)
    omap ic <Plug>(coc-classobj-i)
    xmap ac <Plug>(coc-classobj-a)
    omap ac <Plug>(coc-classobj-a)
endif

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

" unmap unused bind
"inoremap <c-@> <esc>
" }}}
