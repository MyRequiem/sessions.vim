" File:         sessions.vim
" Type:         utility
" Version:      1.0
" Date:         04.09.19
" Author:       MyRequiem <mrvladislavovich@gmail.com>
" License:      MIT
" Description:  Session management: save, load, delete, list.

scriptencoding utf-8

if exists('g:loaded_sessions') && g:loaded_sessions
    finish
endif

let g:loaded_sessions = 1

let g:sessions_dir = get(g:, 'sessions_dir', $HOME . '/.vim/sessions')
if !isdirectory(g:sessions_dir)
    call mkdir(g:sessions_dir, 'p', 0755)
endif

command -nargs=* SessionSave call sessions#SessionSave(<f-args>)

command -nargs=* -complete=customlist,sessions#GetSessionsNames
    \ SessionLoad call sessions#SessionLoad(<f-args>)

command -nargs=* -complete=customlist,sessions#GetSessionsNames
    \ SessionDelete call sessions#SessionDelete(<f-args>)

command -nargs=* SessionList call sessions#SessionList()
