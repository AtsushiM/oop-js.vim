"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/oop-js.vim
"VERSION:  0.1
"LICENSE:  MIT

let s:save_cpo = &cpo
set cpo&vim

if !exists("g:oopjs_linelimitnum")
    let g:oopjs_linelimitnum = 50
endif
if !exists("g:oopjs_dotlimitnum")
    let g:oopjs_dotlimitnum = 3
endif
if !exists("g:oopjs_functionlimitnum")
    let g:oopjs_functionlimitnum = 5
endif
if !exists("g:oopjs_varlimitnum")
    let g:oopjs_varlimitnum = 5
endif

function! oopjs#Check()
    let errors = []

    call oopjs#lineCheck(errors)
    call oopjs#varCheck(errors)
    call oopjs#dotCheck(errors)
    call oopjs#functionCheck(errors)

    if errors != []
        setlocal errorformat=%f:%l:%m
        cgetexpr join(errors, "\n")
        copen
    endif
endfunction

function! oopjs#varCheck(errors)
    let errors = a:errors
    let js = readfile(expand('%'))
    let linenum = 1
    let cnt = 0

    for e in js
        if matchlist(e, '\vvar\s+') != []
            let cnt = cnt + 1

            if cnt > g:oopjs_varlimitnum
                let errors = add(errors, expand('%').':'.linenum.':var <= '.g:oopjs_varlimitnum)
                break
            endif
        endif

        let linenum = linenum + 1
    endfor
endfunction

function! oopjs#functionCheck(errors)
    let errors = a:errors
    let js = readfile(expand('%'))
    let linenum = 1
    let cnt = 0

    for e in js
        if matchlist(e, '\vfunction(.{-})\(') != []
            let cnt = cnt + 1

            if cnt > g:oopjs_functionlimitnum
                let errors = add(errors, expand('%').':'.linenum.':functin <= '.g:oopjs_functionlimitnum)
                break
            endif
        endif

        let linenum = linenum + 1
    endfor
endfunction

function! oopjs#dotCheck(errors)
    let errors = a:errors
    let js = readfile(expand('%'))
    let linenum = 1

    for e in js
        if len(split(e, '\.', 1)) - 1 > g:oopjs_dotlimitnum
            let errors = add(errors, expand('%').':'.linenum.':dot <= '.g:oopjs_dotlimitnum)
        endif

        let linenum = linenum + 1
    endfor
endfunction

function! oopjs#lineCheck(errors)
    let errors = a:errors
    let linenum = line('$')

    if linenum > g:oopjs_linelimitnum
        let errors = add(errors, expand('%').':'.linenum.':'.'line <= '.g:oopjs_linelimitnum)
    endif
endfunction

let &cpo = s:save_cpo
