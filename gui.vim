func! s:gui()
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

func! s:win32()
    set encoding=utf8
    set fileencoding=utf8
    set lines=30 columns=100
    set guifont=consolas:h14
    set guifontwide=黑体
    set pythonthreedll=python36.dll
endfunc

func! s:gtk()
    set guifont=Source\ Code\ Pro\ Medium\ 15
    set guifontwide=黑体
endfunc


if has('gui_running')
    call s:gui()

    if has('win32') && has('gui_running')
        call s:win32()
    endif

    if has('gui_gtk')
        call s:gtk()
    endif
endif
