" Windows-only globals and settings hooks.
let g:on_windows = 1
let g:user_home = $USERPROFILE
let g:config_temp_dir = 'C:/temp'
let g:path_separator = '\'
let g:autosave_ws_interval = 70000
let g:clipboard_timer_interval = 40000
let g:shada_write_command = 'wshada!'
let g:python3_host_prog = g:user_home . '/.pyenv/pyenv-win/versions/3.13/python.exe'
let g:python_host_prog = g:python3_host_prog
let $PYENV_ROOT = g:user_home . '/.pyenv/pyenv-win'

let g:pwmod = 0
let g:sh = &shell
let g:shf = &shellcmdflag
let g:shr = &shellredir
let g:shellpipe = &shellpipe
let g:shq = &shellquote
let g:shxq = &shellxquote

let $PATH = g:user_home . '/AppData/Local/SumatraPDF;' . $PATH

if has('nvim')
lua << EOF
if vim.fn.executable('win32yank.exe') == 1 then
  vim.g.clipboard = {
    name = 'win32yank',
    copy = {
      ['+'] = { 'win32yank.exe', '-i', '--crlf' },
      ['*'] = { 'win32yank.exe', '-i', '--crlf' },
    },
    paste = {
      ['+'] = { 'win32yank.exe', '-o', '--lf' },
      ['*'] = { 'win32yank.exe', '-o', '--lf' },
    },
    cache_enabled = 1,
  }
end
EOF
endif

function! PlatformSettingsOnLoad() abort
    if g:on_ek_computer
        nmap <leader>rv :wshada!<CR>:execute "!start pwsh -Command ResetNeo"<CR>
    endif

    set shell=cmd
    execute 'silent !echo ' . v:servername . ' > ' . shellescape(g:config_temp_dir . '/listen.txt')
    nmap <D-f> <Plug>(easymotion-s2)
    nnoremap <Home> ^
    vnoremap <Home> ^
    set mouse=a

    inoremap <c-p> <c-v>
    cnoremap <c-p> <c-v>
    inoremap <c-v> <c-r><c-p>+
    cnoremap <c-v> <c-r>+
    nnoremap <c-v> p
    nnoremap <M-v> <c-v>
    inoremap <M-v> <c-v>
    nnoremap <M-a> ggVG
endfunction
