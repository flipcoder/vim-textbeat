if !has('python')
    finish
endif

execute 'pyfile '. escape(expand('<sfile>:p:h'),'\') . '/dc.py'

function! dc#playpause()
    py VimDecadence.playpause()
endfunc
function! dc#playline()
    py VimDecadence.playline()
endfunc
function! dc#reload()
    py VimDecadence.reload()
endfunc

au filetype dc set ve=all
command! -nargs=0 DecadencePlayPause call dc#playpause()
command! -nargs=0 DecadencePlayLine call dc#playline()
command! -nargs=0 DecadenceReload call dc#reload()

"command! BufWritePost *.dc DecadenceReload
"nmap <silent> <buffer> <cr> :DecadencePlayPause<cr>

