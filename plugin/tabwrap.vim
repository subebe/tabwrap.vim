if exists('g:loaded_tabwrap')
    finish
endif
let g:loaded_tabwrap = 1

let s:save_cpo = &cpo
set cpo&vim

let g:tabwrap#label_before        = get(g:, 'tabwrap#label_before',        ' ')
let g:tabwrap#label_tab           = get(g:, 'tabwrap#label_tab',           ' !t!!M!:!m! %-8.32(!f!%) ')
let g:tabwrap#label_select        = get(g:, 'tabwrap#label_select',        ' !t!!M!:!m! %-8.32(!f!%) ')
let g:tabwrap#label_after         = get(g:, 'tabwrap#label_after',         '%=    %<%{fnamemodify(getcwd(), ":p:~")}')

let g:tabwrap#file_noname         = get(g:, 'tabwrap#file_noname',         '[No Name]')
let g:tabwrap#file_scratch        = get(g:, 'tabwrap#file_scratch',        '[Scratch]')
let g:tabwrap#file_quickfix       = get(g:, 'tabwrap#file_quickfix',       '[Quickfix List]')

let g:tabwrap#mark_nomodified     = get(g:, 'tabwrap#mark_nomodified',     '')
let g:tabwrap#mark_modified       = get(g:, 'tabwrap#mark_modified',       '+')
let g:tabwrap#mark_nomodifiable   = get(g:, 'tabwrap#mark_nomodifiable',   '-')

let g:tabwrap#mark_tab_nomodified = get(g:, 'tabwrap#mark_tab_nomodified', '')
let g:tabwrap#mark_tab_modified   = get(g:, 'tabwrap#mark_tab_modified',   '*')

let g:tabwrap#default_disable     = get(g:, 'tabwrap#default_disable',     0)

if !g:tabwrap#default_disable
  set tabline=%!tabwrap#create_tabline()
endif

let &cpo = s:save_cpo
