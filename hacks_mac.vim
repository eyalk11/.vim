" macOS-only utility commands.
let g:detect_mod_reg_state = -1

function! DetectRegChangeAndUpdateMark() abort
    let l:current_small_register = getreg('"-')
    let l:current_mod_register = getreg('"')
    if g:detect_mod_reg_state != l:current_small_register
                \ || g:detect_mod_reg_state != l:current_mod_register
        normal! mM
        let g:detect_mod_reg_state = l:current_small_register
    endif
endfunction

augroup MacDetectRegisterChange
    autocmd!
    autocmd CursorMoved * call DetectRegChangeAndUpdateMark()
augroup END
