" Windows-only mappings and helpers.
nnoremap mf <CMD>execute '!start "" ' . shellescape(expand('%:p:h'))<CR>
nnoremap <leader>mF <CMD>execute '!start "" ' . shellescape(getcwd())<CR>

function! TermLOV() abort
    set splitright
    let l:saved_shell = &shell
    set shell=cmd.exe
    let g:neoterm_shell = 'wsl'
    vertical Tnew "~/"
    let &shell = l:saved_shell
endfunction

function! TermOV(use_file_dir) abort
    call CloseVspIfNeed()
    let l:saved_shell = &shell
    let g:neoterm_shell = executable('pwsh') ? 'pwsh' : 'powershell'
    set shell=cmd.exe
    set splitright
    let l:terminal_id = g:neoterm.last_id + 1
    vertical Tnew "~/"
    if a:use_file_dir
        execute l:terminal_id . 'T cd ' . fnameescape(expand('%:p:h'))
    endif
    execute l:terminal_id . 'Tclear'
    let &shell = l:saved_shell
endfunction

function! TermO() abort
    let l:terminal_id = g:neoterm.last_id + 1
    Tnew
    execute l:terminal_id . 'T . /etc/bashrc'
    execute l:terminal_id . 'T . ~/.bash_profile'
    execute l:terminal_id . 'T set -o emacs'
    if g:on_ek_computer
        execute l:terminal_id . 'T bind ''"\C-r": "\C-ahstr -- \C-j"'''
    endif
    execute l:terminal_id . 'Tclear'
endfunction

nnoremap <leader>ot <CMD>tabnew <bar> call TermO()<CR>:startinsert<CR>
nmap <leader>tt <CMD>call TermOV(0)<CR><CMD>call GoRight(0)<CR>:startinsert<CR>
nmap <leader>Tt <CMD>call TermOV(1)<CR><CMD>call GoRight(0)<CR>:startinsert<CR>
nmap <leader>gt <CMD>call TermLOV()<CR><CMD>call GoRight(0)<CR>:startinsert<CR>

function! StashAll() abort
    let l:stash = input('Enter name: ')
    execute '!pwsh -command "StashAll ' . l:stash . '"'
endfunction
nmap <leader>Gs <CMD>call StashAll()<CR>
nmap <leader>ps <CMD>call TogglePS()<CR>

function! DoRf() abort
    let @+ = expand('%:p')
    normal \tt
    call feedkeys("\<C-e>")
    call feedkeys("\<C-v>\<CR>")
endfunction
autocmd FileType ps1 nmap <buffer> <leader>rf <CMD>call DoRf()<CR>

silent! source C:/temp/quicksel.vim
