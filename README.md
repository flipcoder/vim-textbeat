# vim-textbeat

Write music in vim using [textbeat](https://github.com/flipcoder/textbeat)

This is only the plug-in repo. The backend code is in the repo above.

![Screenshot](https://i.imgur.com/HmzNhXf.png)

WORK IN PROGRESS

## Install

Install as a vim plugin.

Clone [textbeat](https://github.com/flipcoder/textbeat).

Run `c:/clones/textbeat/setup.py` to install dependencies and make `textbeat`
python module available. Must use python3!

And the txbt path to your vimrc:

    if has('win32')
        let g:textbeat_path = 'c:/clones/textbeat/txbt.cmd'
    else
        let g:textbeat_path = 'c:/clones/textbeat/txbt'
    endif
