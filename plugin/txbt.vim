if !has('python')
    finish
endif

execute 'pyfile '. escape(expand('<sfile>:p:h'),'\') . '/txbt.py'

function! txbt#play()
    py VimTextbeat.play()
endfunc
function! txbt#stop()
    py VimTextbeat.play()
endfunc
function! txbt#playline()
    py VimTextbeat.playline()
endfunc
function! txbt#reload()
    py VimTextbeat.reload()
endfunc
function! txbt#poll(a)
    py VimTextbeat.poll()
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


au filetype txbt set ve=all
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
    py VimTextbeat.set_txbt_path(vim.eval("g:textbeat_path"))
endif
if exists("g:textbeat_python")
    py VimTextbeat.set_python(vim.eval("g:textbeat_python"))
endif

