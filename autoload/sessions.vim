function! s:showError(str) abort " {{{1
        echohl SpecialChar | echo a:str | echohl NONE
endfunction " 1}}}

function! s:substituteSessionName(name) abort " {{{1
    return substitute(a:name, '\v''|"', '', 'g')
endfunction " 1}}}

" s:getSessionFile(sname) abort {{{1
" return the full path to the session file
function! s:getSessionFile(sname) abort
    let l:sessionfile = printf('%s/%s.vim', g:sessions_dir, a:sname)
    if !empty(glob(substitute(l:sessionfile, '[', '\\[', 'g')))
        return l:sessionfile
    else
        return ''
    endif
endfunction " 1}}}

function! sessions#SessionSave(...) abort " {{{1
    if !len(a:000)
        call <SID>showError('Usage: SessionSave {session_name}')
        return
    endif

    let l:sessionname = <SID>substituteSessionName(join(a:000))

    " if a session with the same name already exists
    if !empty(<SID>getSessionFile(l:sessionname))
        let l:answer = confirm('Session with the same name already exists. ' .
                             \ 'Overwrite it?', "&yes\n&no", 2)
        redraw
        if  l:answer != 1
            echo "Saving session '" . l:sessionname . "' canceled"
            return
        endif
    endif

    execute printf('silent mksession! %s/%s.vim', g:sessions_dir, l:sessionname)
    echo printf("Session '%s' saved", l:sessionname)
endfunction " 1}}}

function! sessions#SessionLoad(...) abort "{{{1
    if !len(a:000)
        call <SID>showError('Usage: SessionLoad {session_name}')
        return
    endif

    let l:sessionname = <SID>substituteSessionName(join(a:000))
    let l:sessionfile = <SID>getSessionFile(l:sessionname)

    if empty(l:sessionfile)
        call <SID>showError(printf("Session '%s' not found", l:sessionname))
        return
    endif

    let l:count_opened_listed_buffers = len(getbufinfo({'buflisted': 1}))
    let l:answer = confirm('Close all opened buffers ' .
                         \ '(total: ' . l:count_opened_listed_buffers  . ')?',
                         \ "&yes\n&no", 2)
    if  l:answer == 1
        " 'bdelete' command is run for each buffer in the buffer list
        execute 'bufdo bdelete'
    endif

    execute 'source ' . l:sessionfile
endfunction " 1}}}

function! sessions#SessionDelete(...) abort " {{{1
    if !len(a:000)
        call <SID>showError('Usage: SessionDelete {session_name}')
        return
    endif

    let l:sessionname = <SID>substituteSessionName(join(a:000))
    let l:sessionfile = <SID>getSessionFile(l:sessionname)

    if empty(l:sessionfile)
        call <SID>showError(printf("Session '%s' not found", l:sessionname))
        return
    endif

    call delete(l:sessionfile)
    echo printf("Session '%s' deleted", l:sessionname)
endfunction " 1}}}

function! sessions#SessionList() abort " {{{1
    let l:sessions_names = <SID>GetSessionsNamesList()
    if !len(l:sessions_names)
        echo 'No saved sessions in ' . fnamemodify(g:sessions_dir, ':~') . '/'
        return
    endif

    let l:i = 1
    for l:session_name in l:sessions_names
        echo string(l:i) . '. ' . l:session_name
        let l:i += 1
    endfor
endfunction " 1}}}

function! s:GetSessionsNamesList() abort " {{{1
    return map(split(globpath(g:sessions_dir, '*.vim'), '\n'),
             \ 'fnamemodify(v:val, ":t:r")')
endfunction " 1}}}

" sessions#GetSessionsNames(ArgLead, CmdLine, CursorPos) abort {{{1
" :h command-completion-customlist
function! sessions#GetSessionsNames(ArgLead, CmdLine, CursorPos) abort
    return <SID>GetSessionsNamesList()
endfunction " 1}}}
