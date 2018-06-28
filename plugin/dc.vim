if !has('python')
    finish
endif

execute 'pyfile '. escape(expand('<sfile>:p:h'),'\') . '/dc.py'

function! dc#play()
    py VimDecadence.play()
endfunc
function! dc#stop()
    py VimDecadence.play()
endfunc
function! dc#playline()
    py VimDecadence.playline()
endfunc
function! dc#reload()
    py VimDecadence.reload()
endfunc
function! dc#poll(a)
    py VimDecadence.poll()
endfunc
function! dc#starttimer()
    if exists('s:dctimer')
        call timer_stop(s:dctimer)
    endif
    let s:dctimer = timer_start(10, 'dc#poll', {'repeat':-1})
endfunc
function! dc#stoptimer()
    call timer_stop(s:dctimer)
    unlet s:dctimer
endfunc


au filetype dc set ve=all
command! -nargs=0 DecadencePlay call dc#play()
command! -nargs=0 DecadencePlayLine call dc#playline()
command! -nargs=0 DecadenceReload call dc#reload()
command! -nargs=0 DecadenceStartTimer call dc#starttimer()
command! -nargs=0 DecadenceStopTimer call dc#stoptimer()

au! BufRead,BufWritePost *.dc DecadenceReload

if !exists("g:decadence_no_mappings") || !g:decadence_no_mappings
    "nmap <silent><buffer> <cr><cr> :DecadencePlay<cr>
    "nmap <silent><buffer> <cr><esc> :DecadenceStop<cr>
    "nmap <silent><buffer> <cr><space> :DecadencePlayLine<cr>
endif

if exists("g:decadence_path")
    py VimDecadence.set_dc_path(vim.eval("g:decadence_path"))
endif
if exists("g:decadence_python")
    py VimDecadence.set_python(vim.eval("g:decadence_python"))
endif

