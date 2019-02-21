au filetype txbt set ve=all

if v:version < 800
    finish
endif
if !has('pythonx')
    finish
endif

execute 'pyxfile '. escape(expand('<sfile>:p:h'),'\') . '/txbt.py'

function! txbt#play()
    pyx VimTextbeat.play()
endfunc
function! txbt#stop()
    pyx VimTextbeat.play()
endfunc
function! txbt#playline()
    pyx VimTextbeat.playline()
endfunc
function! txbt#reload()
    pyx VimTextbeat.reload()
endfunc
function! txbt#poll(a)
    pyx VimTextbeat.poll()
endfunc
function! txbt#starttimer()
    if exists('s:txbttimer')
        call timer_stop(s:txbttimer)
    endif
    let s:txbttimer = timer_start(20, 'txbt#poll', {'repeat':-1})
endfunc
function! txbt#stoptimer()
    call timer_stop(s:txbttimer)
    unlet s:txbttimer
endfunc

command! -nargs=0 TextbeatPlay call txbt#play()
command! -nargs=0 TextbeatPlayLine call txbt#playline()
command! -nargs=0 TextbeatReload call txbt#reload()
command! -nargs=0 TextbeatStartTimer call txbt#starttimer()
command! -nargs=0 TextbeatStopTimer call txbt#stoptimer()

au! BufRead,BufWritePost *.txbt TextbeatReload

if !exists("g:textbeat_no_mappings") || !g:textbeat_no_mappings
    "nmap <silent><buffer> <cr><cr> :TextbeatPlay<cr>
    "nmap <silent><buffer> <cr><esc> :TextbeatStop<cr>
    "nmap <silent><buffer> <cr><space> :TextbeatPlayLine<cr>
endif

if exists("g:textbeat_path")
    pyx VimTextbeat.set_txbt_path(vim.eval("g:textbeat_path"))
else
    pyx VimTextbeat.set_txbt_path("textbeat")
endif

if exists("g:textbeat_python")
    pyx VimTextbeat.set_python(vim.eval("g:textbeat_python"))
else
    pyx VimTextbeat.set_python("python")
endif

