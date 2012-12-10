"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/oop-js.vim
"VERSION:  0.1
"LICENSE:  MIT

if exists("g:loaded_oop_js")
    finish
endif
let g:loaded_oop_js = 1

let s:save_cpo = &cpo
set cpo&vim

if !exists("g:oopjs_autocheck")
    let g:oopjs_autocheck = 0
endif

command! OOPJSCheck call oopjs#Check()

function! s:SetAutoCmd()
    exec 'au BufWritePost *.js call oopjs#Check()'
endfunction

if g:oopjs_autocheck == 1
    au VimEnter * call s:SetAutoCmd()
endif

let &cpo = s:save_cpo
unlet s:save_cpo
