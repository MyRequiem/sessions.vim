" вывести ошибку {{{1
function! s:showError(str)
        echohl SpecialChar | echo a:str | echohl NONE
endfunction " 1}}}

" обработка введенного пользователем имени сессии {{{1
" (удаление начальных и конечных кавычек)
function! s:substituteSessionName(name)
    return substitute(a:name, '\v''|"', '', 'g')
endfunction " 1}}}

" возвращает полный путь к файлу сессии {{{1
function! s:getSessionFile(sname)
    let l:sessionfile = printf('%s/%s.vim', g:sessions_dir, a:sname)
    if !empty(glob(l:sessionfile))
        return l:sessionfile
    else
        return ''
    endif
endfunction " 1}}}

" создание сессии {{{1
function! sessions#SessionSave(...)
    if !len(a:000)
        call <SID>showError('Usage: SessionSave {session-name}')
        return
    endif

    let l:sessionname = <SID>substituteSessionName(join(a:000))

    execute printf('silent mksession! %s/%s.vim', g:sessions_dir, l:sessionname)
    echo printf("Session '%s' saved", l:sessionname)
endfunction " 1}}}

" вывод списка сохраненных сессий {{{1
function! sessions#SessionList()
    let l:sessions = systemlist('ls ' . g:sessions_dir . '/*.vim 2>/dev/null')

    if !len(l:sessions)
        echo 'No saved sessions in ' . fnamemodify(g:sessions_dir, ':~') . '/'
        return
    endif

    let l:i = 1
    for l:session in l:sessions
        echo string(l:i) . '. ' . fnamemodify(l:session, ':t:r')
        let l:i += 1
    endfor
endfunction " 1}}}

" удаление сессии {{{1
function! sessions#SessionDelete(...)
    if !len(a:000)
        call <SID>showError('Usage: SessionDelete {session-name}')
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

" загрузка сессии {{{1
function! sessions#SessionLoad(...)
    if !len(a:000)
        call <SID>showError('Usage: SessionLoad {session-name}')
        return
    endif

    let l:sessionname = <SID>substituteSessionName(join(a:000))
    let l:sessionfile = <SID>getSessionFile(l:sessionname)

    if empty(l:sessionfile)
        call <SID>showError(printf("Session '%s' not found", l:sessionname))
        return
    endif

    let l:prompt = "Loading session '%s'. Close all open buffers [y/N]?: "
    let l:answer = input(printf(l:prompt, l:sessionname))
    if  l:answer ==? 'y'
        " для каждого буфера запускается 'bdelete'
        execute 'bufdo bdelete'
    endif

    execute 'source ' . l:sessionfile
endfunction " 1}}}
