"============================================================================
"File:        mooncheck.vim
"Description: moon static analysis using mooncheck
"Maintainer:  Nymphium
"License:     This program is free software. It comes without any warranty,
"             to the extent permitted by applicable law. You can redistribute
"             it and/or modify it under the terms of the Do What The Fuck You
"             Want To Public License, Version 2, as published by Sam Hocevar.
"             See http://sam.zoy.org/wtfpl/COPYING for more details.
"============================================================================


if exists('g:loaded_syntastic_moon_mooncheck_checker')
    finish
endif
let g:loaded_syntastic_moon_mooncheck_checker = 1

let s:save_cpo = &cpo
set cpo&vim

function! SyntaxCheckers_moon_mooncheck_GetHighlightRegex(item)
    let term = matchstr(a:item['text'], '\m''\zs\S\+\ze''')
    if term !=# ''
        return '\V\<' . escape(term, '\') . '\>'
    endif

    let term = matchstr(a:item['text'], '\m\(accessing undefined\|setting non-standard global\|' .
                \ 'setting non-module global\|unused global\) variable \zs\S\+')
    if term ==# ''
        let term = matchstr(a:item['text'], '\mvariable \zs\S\+\ze was previously defined')
    endif
    if term ==# ''
        let term = matchstr(a:item['text'], '\munused \(variable\|argument\|loop variable\) \zs\S\+')
    endif
    if term ==# ''
        let term = matchstr(a:item['text'], '\m\(value assigned to variable\|value of argument\|' .
                \ 'value of loop variable\) \zs\S\+')
    endif
    if term ==# ''
        let term = matchstr(a:item['text'], '\mvariable \zs\S\+\ze is never set')
    endif

    return term !=# '' ? '\V\<' . escape(term, '\') . '\>' : ''
endfunction

function! SyntaxCheckers_moon_mooncheck_GetLocList() dict
    let makeprg = self.makeprgBuild({})

    let errorformat = '%E%f:%l: Error: %m,' .
		\ '%W%f:%l: %m,' .  '%-G%.%#'

    return SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat,
        \ 'subtype': 'Style',
        \ 'returns': [0, 1, 2] })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'moon',
    \ 'name': 'mooncheck' })

let &cpo = s:save_cpo
unlet s:save_cpo

