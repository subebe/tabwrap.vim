function! s:convert(label) abort
  let label = a:label

  " カレントタブを閉じる
  let label = substitute(label, '!xx!\C', '%999X', 'g')
  let label = substitute(label, '!XX!\C', '%X', 'g')
  return label
endfunction

function! s:tab_convert(label, tabnr) abort
  let tabbuflist = tabpagebuflist(a:tabnr)
  let curbuf = tabbuflist[tabpagewinnr(a:tabnr) - 1]

  let label = a:label

  " タブの番号
  let label = substitute(label, '!t!\C', a:tabnr, 'g')

  " 修正フラグ
  let modifiable = ''
  if getbufvar(curbuf, '&modified')
    let modifiable = g:tabwrap#mark_modified
  elseif !getbufvar(curbuf, '&modifiable')
    let modifiable = g:tabwrap#mark_nomodifiable
  else
    let modifiable = g:tabwrap#mark_nomodified
  endif
  let label = substitute(label, '!m!\C', modifiable, 'g')

  " タブの修正フラグ
  let tab_modifiable = ''
  if len(filter(copy(tabbuflist), 'getbufvar(v:val, "&modified")'))
    let tab_modifiable = g:tabwrap#mark_tab_modified
  else
    let tab_modifiable = g:tabwrap#mark_tab_nomodified
  endif
  let label = substitute(label, '!M!\C', tab_modifiable, 'g')

  " タブのウィンドウ数
  let wincount = len(tabbuflist)
  let label = substitute(label, '!w!\C', wincount, 'g')

	" タブのウィンドウ数(複数の場合のみ)
  if wincount <= 1
    let label = substitute(label, '!W!\C', '', 'g')
  else
    let label = substitute(label, '!W!\C', wincount, 'g')
  endif

  " ファイル名
  let filename = fnamemodify(bufname(curbuf), ':t')
  let buftype = getbufvar(curbuf, '&buftype')
  if filename != ''
    let name = filename
  elseif buftype =~ 'quickfix'
    let name = g:tabwrap#file_quickfix
  elseif buftype =~ 'nofile'
    let name = g:tabwrap#file_scratch
  else
    let name = g:tabwrap#file_noname
  endif
  let label = substitute(label, '!f!\C', name, 'g')

  " タブを閉じる
  let label = substitute(label, '!x!\C', '%'.a:tabnr.'X', 'g')
  let label = substitute(label, '!X!\C', '%X', 'g')

  return label
endfunction

function! s:is_selected_tab(tabnr) abort
    return a:tabnr is tabpagenr() ? v:true : v:false
endfunction

function! tabwrap#create_tabline() abort
  let labels = []
  for tabnr in range(1, tabpagenr('$'))
    let label = s:is_selected_tab(tabnr) ? g:tabwrap#label_select : g:tabwrap#label_tab
    let label = s:convert(label)
    let label = s:tab_convert(label, tabnr)

    " タブ開始
    if s:is_selected_tab(tabnr)
      let label = '%#TablineSel#%'.tabnr.'T'.label.'%#Tabline#'
    else
      let label = '%'.tabnr.'T'.label
    endif

    call add(labels, label)
  endfor
  let tabs = join(labels, '')

  let before = s:convert(g:tabwrap#label_before)
  let after = s:convert(g:tabwrap#label_after)
  return before.'%#Tabline#'.tabs.'%#TablineFill#%T'.after
endfunction
