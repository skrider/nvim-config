if exists(':AsyncRun')
  nnoremap <buffer><silent> <F9> :<C-U>AsyncRun python -u "%"<CR>
endif

nmap <buffer> <space>x <Plug>JupyterExecute
nmap <buffer> <space>xa <Plug>JupyterExecuteAll

nnoremap <buffer> nc ?%%<cr>jV/%%<cr>k

let b:nrrw_aucmd_create = "silent %s/^#.//g"
let b:nrrw_aucmd_close = "silent %s/^/# /g"

setlocal comments+=f:#
setlocal formatoptions+=r
setlocal formatoptions-=a

" Do not wrap Python source code.
set nowrap
set sidescroll=5
set sidescrolloff=2
set colorcolumn=100

set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=4    " number of spaces to use for autoindent
set expandtab       " expand tab to spaces so that tabs are spaces

" For delimitMate
let b:delimitMate_matchpairs = "(:),[:],{:}"
