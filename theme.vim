" 语法高亮
packadd! python-syntax
packadd! plantuml-syntax
packadd! haskell-syntax
"packadd! c-syntax.vim
packadd! fish-syntax
packadd! vala-syntax

"set background=dark

func! theme#PaperColor()
    let g:PaperColor_Theme_Options = {
                \   'language': {
                \     'python': {
                \       'highlight_builtins' : 1
                \     },
                \     'cpp': {
                \       'highlight_standard_library': 1
                \     },
                \     'c': {
                \       'highlight_builtins' : 1
                \     }
                \   }
                \ }
    colorscheme PaperColor
endfunc

func! theme#Sonokai()
    packadd! sonokai
    let g:sonokai_style = 'default' " default, atlantis, andromeda, shusia, maia, espresso
    let g:sonokai_better_performance = 1
    let g:sonokai_transparent_background = 1
    let g:sonokai_diagnostic_text_highlight = 1
    colorscheme sonokai

    let conf = sonokai#get_configuration()
    let palette = sonokai#get_palette(conf.style, conf.colors_override)

    " TODO 交换mod颜色
    " let tmp = g:airline#themes#sonokai#palette.insert.airline_a
    " let g:airline#themes#sonokai#palette.insert.airline_a =
    " \ g:airline#themes#sonokai#palette.normal.airline_a
    " let g:airline#themes#sonokai#palette.normal.airline_a = tmp
endfunc

func! theme#JellyBeans()
    colorscheme jellybeans
endfunc
