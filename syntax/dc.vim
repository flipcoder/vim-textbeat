if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

syn match dcComment  '^;.*'
syn match dcBus '^%.*'
"syn match dcLabel '|\w*:'
"syn match dcCall ':\w*|'
syn match dcNoteNumber '[b#]*[0-9]+'
syn match dcNoteName '[A-G][b#]*'
syn match dcPop '|||'
syn region dcLabel start='|^|' end=':'
syn region dcCall start=':' end='|'

"syn keyword dcKeywords m ma maj min dim dom mu

hi def link dcBus Macro
hi def link dcComment Comment
hi def link dcLabel Label
hi def link dcCall Label
hi def link dcNoteNumber Number
hi def link dcNoteName Number
hi def link dcPop Label
"hi def link dcNoteNumber Number
"hi def link dcNoteName Number

let b:current_syntax = "dc"
