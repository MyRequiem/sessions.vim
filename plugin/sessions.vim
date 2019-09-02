" File:         sessions.vim
" Version:      1.0
" Date:         31.07.19
" Author:       MyRequiem <mrvladislavovich {at} gmail.com>
" License:      MIT
" Description:  Управление сессиями: создание, вывод списка, открытие, удаление.

scriptencoding utf-8

if exists('g:loaded_sessions') && g:loaded_sessions
    finish
endif

let g:loaded_sessions = 1

let g:sessions_dir = get(g:, 'sessions_dir', $HOME . '/.vim/sessions')
if !isdirectory(g:sessions_dir)
    call mkdir(g:sessions_dir, 'p')
endif

command -nargs=* SessionList    call sessions#SessionList()
command -nargs=* SessionLoad    call sessions#SessionLoad(<f-args>)
command -nargs=* SessionSave    call sessions#SessionSave(<f-args>)
command -nargs=* SessionDelete  call sessions#SessionDelete(<f-args>)
