if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

syn match txbtComment  '^;.*'
syn match txbtBus '^%.*'
"syn match txbtLabel '|\w*:'
"syn match txbtCall ':\w*|'
syn match txbtNoteNumber '[b#]*[0-9]+'
syn match txbtNoteName '[A-G][b#]*'
"syn match txbtPop '|||'
"syn region txbtLabel start='|^|' end=':'
"syn region txbtCall start=':' end='|'

"syn keyword txbtKeywords m ma maj min dim dom mu

hi def link txbtBus Macro
hi def link txbtComment Comment
hi def link txbtLabel Label
hi def link txbtCall Label
hi def link txbtNoteNumber Number
hi def link txbtNoteName Number
hi def link txbtPop Label
"hi def link txbtNoteNumber Number
"hi def link txbtNoteName Number

let b:current_syntax = "txbt"
