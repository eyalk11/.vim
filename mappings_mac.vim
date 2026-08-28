" macOS-only mappings and helpers.
nmap <c-w> <CMD>tabclose<CR>

nnoremap mf <CMD>execute '!open ' . shellescape(expand('%:p:h'))<CR>
nnoremap <leader>mF <CMD>execute '!open ' . shellescape(getcwd())<CR>

" Preserve the Mac branch's repo shortcut after the common Git mappings load.
nmap <leader>gc <CMD>cd ~/compare-my-stocks<CR>

" On Mac, this picker changes the tab-local directory.
function! FzfDirChooseFile() abort
    call fzf#run({
        \ 'source': uniq(sort(map(copy(g:dirs), 'tolower(v:val)'))),
        \ 'sink': function('TcdDirPlug'),
        \ 'options': '-i --preview "ls {} | head -50"'
    \ })
endfunction

function! TermOV(use_file_dir) abort
    call CloseVspIfNeed()
    let l:cwd = a:use_file_dir ? expand('%:p:h') : expand('~')
    call luaeval('Snacks.terminal.open(nil, { cwd = _A, win = { position = "right", width = 0.4 } })', l:cwd)
endfunction

function! TermO() abort
    call luaeval('Snacks.terminal.open()')
endfunction

nnoremap <leader>ot <CMD>tabnew <bar> call TermO()<CR>:startinsert<CR>
nmap <leader>tt <CMD>call TermOV(0)<CR><CMD>call GoRight(0)<CR>:startinsert<CR>
nmap <leader>Tt <CMD>call TermOV(1)<CR><CMD>call GoRight(0)<CR>:startinsert<CR>

function! StashAll() abort
    let l:stash = input('Enter name: ')
    execute '!git stash push -m ' . shellescape(l:stash)
endfunction
nmap <leader>Gs <CMD>call StashAll()<CR>

function! s:MmdReport(name, code, err) abort
    if a:code == 0
        echohl MoreMsg | echom 'mmd compile OK: ' . a:name | echohl None
    else
        echohl ErrorMsg | echom 'mmd compile FAIL(' . a:code . '): ' . a:name . (empty(a:err) ? '' : ' — ' . a:err) | echohl None
    endif
endfunction

function! CompileMmd() abort
    let l:src = expand('%:p')
    let l:name = expand('%:t')
    let l:dst = expand('%:p:r') . '.pdf'
    let l:script = expand('~/research/compile_mmd.sh')
    let l:node = expand('~/.nvm/versions/node/v24.15.0/bin')
    let l:cmd = ['sh', '-c', printf('PATH=%s:$PATH %s %s %s',
        \ shellescape(l:node), shellescape(l:script), shellescape(l:src), shellescape(l:dst))]
    echo 'mmd compiling: ' . l:name . '...'
    let l:stderr_lines = []
    if has('nvim')
        call jobstart(l:cmd, {
            \ 'on_stderr': {_, data, __ -> extend(l:stderr_lines, filter(copy(data), '!empty(v:val)'))},
            \ 'on_exit': {_, code, __ -> s:MmdReport(l:name, code, join(l:stderr_lines, ' | '))},
            \ })
    else
        call job_start(l:cmd, {
            \ 'err_cb': {_, msg -> add(l:stderr_lines, msg)},
            \ 'exit_cb': {_, code -> s:MmdReport(l:name, code, join(l:stderr_lines, ' | '))},
            \ })
    endif
endfunction

function! ToggleMmdAutoCompile() abort
    let b:mmd_autocompile = !get(b:, 'mmd_autocompile', 1)
    echo 'mmd autocompile (' . expand('%:t') . '): ' . (b:mmd_autocompile ? 'ON' : 'OFF')
endfunction

augroup MmdAutoCompile
    autocmd!
    autocmd BufWritePost *.mmd if get(b:, 'mmd_autocompile', 1) | call CompileMmd() | endif
augroup END

augroup MmdMappings
    autocmd!
    autocmd BufRead,BufNewFile *.mmd nnoremap <buffer> <leader>mc :call CompileMmd()<CR>
    autocmd BufRead,BufNewFile *.mmd nnoremap <buffer> <leader>ma :call ToggleMmdAutoCompile()<CR>
augroup END
