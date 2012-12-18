"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/oop-js.vim
"VERSION:  0.1
"LICENSE:  MIT

let s:save_cpo = &cpo
set cpo&vim

if !exists("g:oopjs_ignorecheckfile")
    let g:oopjs_ignorecheckfile = ['test\.js', 'min\.js', 'combine\.js', 'lib\/.\+\.js']
endif
if !exists("g:oopjs_linelimitnum")
    let g:oopjs_linelimitnum = 50
endif
if !exists("g:oopjs_varlimitnum")
    let g:oopjs_varlimitnum = 5
endif
if !exists("g:oopjs_dotlimitnum")
    let g:oopjs_dotlimitnum = 3
endif
if !exists("g:oopjs_iflimitnum")
    let g:oopjs_iflimitnum = 5
endif
if !exists("g:oopjs_elselimitnum")
    let g:oopjs_elselimitnum = 1
endif
if !exists("g:oopjs_switchlimitnum")
    let g:oopjs_switchlimitnum = 1
endif
if !exists("g:oopjs_forlimitnum")
    let g:oopjs_forlimitnum = 3
endif
if !exists("g:oopjs_whilelimitnum")
    let g:oopjs_whilelimitnum = 3
endif
if !exists("g:oopjs_dolimitnum")
    let g:oopjs_dolimitnum = 1
endif
if !exists("g:oopjs_anonymousfunctionlimitnum")
    let g:oopjs_anonymousfunctionlimitnum = 5
endif
if !exists("g:oopjs_namedfunctionlimitnum")
    let g:oopjs_namedfunctionlimitnum = 5
endif

let s:error_open = 0
function! oopjs#Check()
    let jspath = expand('%:p')

    for e in g:oopjs_ignorecheckfile
        if matchlist(jspath, e) != []
            return 0
        endif
    endfor

    let errors = []

    call oopjs#lineCheck(errors)
    call oopjs#varCheck(errors)
    call oopjs#dotCheck(errors)
    call oopjs#ifCheck(errors)
    call oopjs#elseCheck(errors)
    call oopjs#switchCheck(errors)
    call oopjs#forCheck(errors)
    call oopjs#whileCheck(errors)
    call oopjs#doCheck(errors)
    call oopjs#anonymousfunctionCheck(errors)
    call oopjs#namedfunctionCheck(errors)

    if errors != []
        setlocal errorformat=%f:%l:%m
        cgetexpr join(errors, "\n")
        copen
        let s:error_open = 1

        return 0
    elseif s:error_open == 1
        cclose
        let s:error_open = 0
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

function! oopjs#anonymousfunctionCheck(errors)
    let errors = a:errors
    let js = readfile(expand('%'))
    let linenum = 1
    let cnt = 0

    for e in js
        if matchlist(e, '\vfunction(\s{-})\(') != []
            let cnt = cnt + 1

            if cnt > g:oopjs_anonymousfunctionlimitnum
                let errors = add(errors, expand('%').':'.linenum.':anonymous_function <= '.g:oopjs_anonymousfunctionlimitnum)
                break
            endif
        endif

        let linenum = linenum + 1
    endfor
endfunction

function! oopjs#namedfunctionCheck(errors)
    let errors = a:errors
    let js = readfile(expand('%'))
    let linenum = 1
    let cnt = 0

    for e in js
        if matchlist(e, '\vfunction\s(.+)\(') != []
            let cnt = cnt + 1

            if cnt > g:oopjs_namedfunctionlimitnum
                let errors = add(errors, expand('%').':'.linenum.':named_function <= '.g:oopjs_namedfunctionlimitnum)
                break
            endif
        endif

        let linenum = linenum + 1
    endfor
endfunction

function! oopjs#ifCheck(errors)
    let errors = a:errors
    let js = readfile(expand('%'))
    let linenum = 1
    let cnt = 0

    for e in js
        if matchlist(e, '\vif(\s*)\(') != []
            let cnt = cnt + 1

            if cnt > g:oopjs_iflimitnum
                let errors = add(errors, expand('%').':'.linenum.':if <= '.g:oopjs_iflimitnum)
                break
            endif
        endif

        let linenum = linenum + 1
    endfor
endfunction
function! oopjs#elseCheck(errors)
    let errors = a:errors
    let js = readfile(expand('%'))
    let linenum = 1
    let cnt = 0

    for e in js
        if matchlist(e, '\velse(.*)(\(|\{)') != []
            let cnt = cnt + 1

            if cnt > g:oopjs_elselimitnum
                let errors = add(errors, expand('%').':'.linenum.':else <= '.g:oopjs_elselimitnum)
                break
            endif
        endif

        let linenum = linenum + 1
    endfor
endfunction
function! oopjs#switchCheck(errors)
    let errors = a:errors
    let js = readfile(expand('%'))
    let linenum = 1
    let cnt = 0

    for e in js
        if matchlist(e, '\vswitch(\s*)\(') != []
            let cnt = cnt + 1

            if cnt > g:oopjs_switchlimitnum
                let errors = add(errors, expand('%').':'.linenum.':switch <= '.g:oopjs_switchlimitnum)
                break
            endif
        endif

        let linenum = linenum + 1
    endfor
endfunction
function! oopjs#forCheck(errors)
    let errors = a:errors
    let js = readfile(expand('%'))
    let linenum = 1
    let cnt = 0

    for e in js
        if matchlist(e, '\vfor(\s*)\(') != []
            let cnt = cnt + 1

            if cnt > g:oopjs_forlimitnum
                let errors = add(errors, expand('%').':'.linenum.':for <= '.g:oopjs_forlimitnum)
                break
            endif
        endif

        let linenum = linenum + 1
    endfor
endfunction
function! oopjs#whileCheck(errors)
    let errors = a:errors
    let js = readfile(expand('%'))
    let linenum = 1
    let cnt = 0

    for e in js
        if matchlist(e, '\vwhile(\s*)\(') != []
            let cnt = cnt + 1

            if cnt > g:oopjs_whilelimitnum
                let errors = add(errors, expand('%').':'.linenum.':while <= '.g:oopjs_whilelimitnum)
                break
            endif
        endif

        let linenum = linenum + 1
    endfor
endfunction
function! oopjs#doCheck(errors)
    let errors = a:errors
    let js = readfile(expand('%'))
    let linenum = 1
    let cnt = 0

    for e in js
        if matchlist(e, '\vdo(\s*)\{') != []
            let cnt = cnt + 1

            if cnt > g:oopjs_dolimitnum
                let errors = add(errors, expand('%').':'.linenum.':do <= '.g:oopjs_dolimitnum)
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
