set sessionoptions-=curdir
set sessionoptions+=sesdir
set sessionoptions-=blank
set sessionoptions+=winpos
set sessionoptions+=resize
set sessionoptions+=winsize
set sessionoptions+=unix
set sessionoptions+=slash

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

nnoremap <silent> <c-f9> :call SaveSpace()<cr>
nnoremap <silent> <c-f10> :call LoadSpace()<cr>
