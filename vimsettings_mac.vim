" macOS-only globals and settings hooks.
let g:on_windows = 0
let g:user_home = $HOME
let g:config_temp_dir = expand('~/temp')
let g:path_separator = '/'
let g:autosave_ws_interval = 10000
let g:clipboard_timer_interval = 3000
let g:shada_write_command = 'wshada'
let g:python3_host_prog = '/usr/local/bin/python3.13'
let g:python_host_prog = g:python3_host_prog
let $PYENV_ROOT = g:user_home . '/.pyenv'
let $PATH = expand('~/.dotnet/tools:$HOME/.nvm/versions/node/v24.15.0/bin:$HOME/bin:$HOME/.local/bin:/usr/local/bin:') . $PATH

function! ResetNvimUnix() abort
    silent! wshada!
    let l:saved_shell = &shell
    let l:saved_shcf = &shellcmdflag
    set shell=/bin/sh
    set shellcmdflag=-c
    try
        let l:ppid = trim(system('ps -o ppid= -p ' . getpid()))
        let l:pcmd = trim(system('ps -o command= -p ' . l:ppid))
    finally
        let &shell = l:saved_shell
        let &shellcmdflag = l:saved_shcf
    endtry
    if l:pcmd !~? 'nvim-qt\|goneovim\|neovide\|macvim\|vimr'
        echoerr 'ResetNvimUnix: unrecognized parent: ' . l:pcmd
        return
    endif
    let l:exe = split(l:pcmd, '\s\+')[0]
    call system('/bin/sh -c ' . shellescape('( kill ' . l:ppid . ' && sleep 0.4 && ' . shellescape(l:exe) . ' >/dev/null 2>&1 & ) &'))
    qa!
endfunction

" Ask Claude about a Vim error, including the tail of the Vim log.
command! -nargs=+ ClaudeLastError call s:ClaudeLastError(<q-args>)
function! s:ClaudeLastError(error) abort
    let l:log_path = expand('~/.vim/vimlog.log')
    let l:lines = filereadable(l:log_path) ? readfile(l:log_path) : []
    let l:tail = len(l:lines) > 400 ? l:lines[-400:] : l:lines
    let l:tmp = tempname()
    call writefile([
        \ 'Analyze this vim error and suggest a fix.',
        \ '',
        \ 'Error reported by the user:',
        \ a:error,
        \ '',
        \ 'Tail of ~/.vim/vimlog.log:',
        \ '---'] + l:tail + ['---'], l:tmp)
    let l:cmd = 'claude "$(cat ' . shellescape(l:tmp) . ')"'
    call luaeval('Snacks.terminal.open(_A, { win = { position = "right", width = 0.4 } })', l:cmd)
endfunction

function! PlatformSettingsOnLoad() abort
    if g:on_ek_computer
        nmap <leader>rv :call ResetNvimUnix()<CR>
    endif

    execute 'silent !echo ' . shellescape(v:servername) . ' > ' . shellescape(g:config_temp_dir . '/listen.txt')
    nmap <D-f> <Plug>(easymotion-s2)
    nnoremap <Home> ^
    vnoremap <Home> ^
    set mouse=a

    inoremap <D-v> <c-r><c-p>+
    cnoremap <D-v> <c-r>+
    nnoremap <D-v> p
    vnoremap <D-v> "+p
    nnoremap <D-a> ggVG
    nnoremap <D-c> "+y
    vnoremap <D-c> "+y
    vnoremap <D-x> "+d
endfunction
