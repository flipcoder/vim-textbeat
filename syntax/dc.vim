if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

syn match dcComment  '^#.*'
syn match dcBus '^%.*'
"syn match dcNoteNumber '[b#]*[0-9]+'
"syn match dcNoteName '[A-G][b#]*'

hi def link dcBus Macro
hi def link dcComment Comment
"hi def link dcNoteNumber Number
"hi def link dcNoteName Number

let b:current_syntax = "dc"
