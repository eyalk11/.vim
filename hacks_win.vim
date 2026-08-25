" Windows-only utility commands.
command! -nargs=1 P call RunPS(<f-args>)
command! -nargs=0 TP call TogglePS()

function! GrepPy() abort
    call AddFiles("find . -iname '*.py' | grep -v __init__")
endfunction

function! AddFiles(grep) abort
    redir => l:output
    call RunPS('RunBash "' . a:grep . '"')
    redir END
    for l:path in split(l:output, '\n')
        if filereadable(l:path)
            execute 'edit ' . fnameescape(l:path)
        endif
    endfor
endfunction

function! RunPS(command) abort
    if g:pwmod == 0
        call TogglePS()
        execute 'silent! !Import-Module ' . shellescape(g:user_home . '/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1') . ';' . a:command
        call TogglePS()
    else
        execute 'silent! !Import-Module ' . shellescape(g:user_home . '/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1') . ';' . a:command
    endif
endfunction

function! TogglePS() abort
    if g:pwmod
        let &shell = g:sh
        let &shellcmdflag = g:shf
        let &shellredir = g:shr
        let &shellpipe = g:shellpipe
        let &shellquote = g:shq
        let &shellxquote = g:shxq
    else
        let &shell = executable('pwsh') ? 'pwsh' : 'powershell'
        let &shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
        let &shellredir = ' | Out-File -Encoding UTF8 %s; exit $LastExitCode'
        let &shellpipe = ' | Out-File -Encoding UTF8 %s; exit $LastExitCode'
        set shellquote= shellxquote=
    endif
    let g:pwmod = !g:pwmod
endfunction
