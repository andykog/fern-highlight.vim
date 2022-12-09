function! s:focus(helper, key) abort
  if len(a:key) < 1
    return
  endif
  let index = fern#internal#node#index(a:key, a:helper.fern.visible_nodes)
  if index is# -1
    return s:focus(a:helper, a:key[:-2])
  endif

  call a:helper.sync.focus_node(a:key)
endfunction

function! s:handleBufEnter() abort
  let path = expand('%:p')
  if path[0:6] ==# 'fern://'
    let g:fernHighlightHelper = fern#helper#new()
  elseif exists("g:fernHighlightHelper")
    let root = g:fernHighlightHelper.sync.get_root_node()._path
    if path[0:len(root)-1] ==# root
      let path = substitute(path, root, '', '')
      call s:focus(g:fernHighlightHelper, split(path, '/'))
    endif
  endif
endfunction

autocmd BufEnter * call s:handleBufEnter()
