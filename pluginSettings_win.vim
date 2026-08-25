" Windows-only plugin settings.
set shell=cmd.exe
let $FZF_DEFAULT_OPTS = '--history=' . g:user_home . '/.fzf/history_file'
let g:fzf_action = {'ctrl-o': '!start'}

let g:vimtex_view_method = 'general'
let g:vimtex_compiler_progname = 'nvr'
let g:vimtex_view_general_viewer = 'SumatraPDF'
let g:vimtex_view_general_options = '-reuse-instance -forward-search @tex @line @pdf'
let g:vimtex_view_general_options_latexmk = '-reuse-instance'

let g:Lf_Rg = 'C:/ProgramData/chocolatey/bin/rg.EXE'
let g:neoformat_enabled_powershell = ['PowerShellBeautifier']
