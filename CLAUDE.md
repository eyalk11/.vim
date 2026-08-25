# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal Neovim (and legacy Vim) configuration.


---
## Instructions 

- Note as a general search takes a lot of time, try to restrict to relevant files (i.e. plugins) , or git ls-files
- try to locate things in the relevant files mentioned here


## Key files

### `.vimrc` — entry point
Sets global flags and sources all other files via `Runit()`. Key globals:
- `g:minimal` (0/1) — when 1, loads platform globals plus common/platform mappings only; useful for fast startup
- `g:on_ek_computer` — true when `$USERNAME` matches `karni`; gates personal-machine-only code
- `g:vimloc` — path to `~/.vim` (derived from `&packpath`); used everywhere to build source paths

`.vimrc` selects `g:platform` once (`win` or `mac`). `Runit()` loads each common file followed by its matching platform companion: `pluginSettings.vim` + `_win`/`_mac` → `newplug.vim` → `t.lua` → `secret.vim` → `hacks.vim` + companion → `myinit.lua` → `math.vim` → `mappings.vim` + companion. Windows-only `quicksel.vim` loading lives in `mappings_win.vim`.

### `vimsettings.vim` — vim options and global state
Sourced first (before plugins). Sets:
- Python interpreter paths (pyenv-win, Python 3.13)
- Shell state saved to `g:sh*` vars so `TogglePS()` in hacks.vim can switch between cmd and PowerShell
- Core vim options: `undofile`, `shada`, `clipboard+=unnamed`, `tabstop=4/shiftwidth=4/expandtab`, spell, `synmaxcol=300`, `jumpoptions=stack`
- Timers started in `OnLoad()`: `TimerFunc` (10s, saves shada + mark M), `TimerFuncB` (3s, clipboard sync), `GetLine` (20s), `SaveInsertsFunc` (200s), `LazyIt` (1s, one-shot)
- `OnLoad()` / `OnEnd()` VimEnter/VimLeave hooks; `PyAS()` enables auto-save for python/ps1/lua/vim filetypes
- `PY` command alias for `python3` (`:PY code`)
- Writes vim messages to `~/.vim/vimlog.log`

Platform globals, clipboard integration, GUI paste mappings, and restart behavior live in `vimsettings_win.vim` and `vimsettings_mac.vim`. Keep shared options in `vimsettings.vim`.

### `hacks.vim` — large utility function library
The biggest vimscript file. Key functions/commands:

**Window/buffer tracking:**
- `SaveLastWindow()` / `LastWindow` command — tracks last visited real buffer for quick re-open
- `SaveLastDir()` — persists visited dirs to `dirs.cache` (pickle via Python)
- `TimerFuncB()` — clipboard watcher: shifts registers `v→w` when external copy detected

**Search/match commands:**
- `:M <pat>` / `:MC <pat>` / `:MESC <pat>` — collect matching lines into quickfix (literal / case-insensitive / raw regex)
- `:VG <pat> [glob]` — vimgrep across files
- `:GL /pat/py expr` / `:GL /pat/rpy expr` — Python-powered substitution (`RunPython`/`RunPython2`)

**Navigation:**
- `Gonext()` / `Goprev()` — smart next/prev that works on either loclist or quickfix
- `TN` command — open file in tab, reuse existing tab if already open
- `GotoMap(key)` — find where a mapping was defined (also in myinit.lua)

**Shell/PowerShell:**
- `TogglePS()` — switches vim's `&shell` between cmd and PowerShell (state saved in `g:sh*`)
- `RunPS(cmd)` — run a command in PowerShell

**File operations:**
- `:DeleteMe` — delete current file + buffer (with confirmation)
- `:MoveMe [dest]` — rename/move current file and update buffer
- `CopyPath()` — copy full path to `+` register

**Marks:**
- Auto-sets mark `I` on `InsertLeave`, mark `M` on modification/`CursorMoved`
- `DetectRegChangeAndUpdateMark()` — updates mark M on any register change

**Misc:**
- `MinExec(cmd)` — capture command output as string
- `Exec(cmd)` — capture output into new tab
- `CloseAllBuffersButCurrent()` / `CloseAllWindowsButCurrent()` — cleanup commands
- `ReplaceCasing(word, old)` — case-insensitive project-wide rename
- `ToggleVerbose()` — toggle verbose logging to `~/.vim/verbose.log`
- `MakeJson()` — generate `.vimspector.json` for debugpy
- `CreateList` (`:CL`) — convert lines to a quoted comma-separated list
- `SaveLastReg()` / yank ring — on yank, shifts `@2`–`@9` to maintain history
- `"<c-r>` — fzf register picker

### `newplug.vim` — canonical plugin list (current)
The **primary** plugin list (work-specific variant but we are in work settings). All plugins declared with `Plugit`, organized in sections: Core, UI, Navigation, Editing, Git, File Management, Search, LSP/Completion, Language Specific, Utilities. Commented-out lines are intentionally disabled — don't re-enable without checking why.

`newplug_.vim` is the original which you shouldn't edit . 
### `mappings.vim` — keymaps and custom functions
Contains all keybindings and non-trivial vimscript functions:
- `DiagnosticsGitOnly()` — filters LSP diagnostics to only files tracked by git
- `AlignWithTopLine()` / `ConditionalAlign()` / `FormatCurrentBlock()` — Python-aware indentation alignment (uses autopep8)
- `<leader>xf` / `<leader>XF` — show filtered LSP diagnostics (quickfix/loclist)

**Important mapping primitives** (used as building blocks in compound mappings):
- `mc` → `cd %:p:h` — change cwd to current file's directory
- `\vn` / `<leader>vn` → open a vsplit (`CloseVspIfNeed()` + `vnew`)
- `<leader>gf` → `Telescope git_files` — fuzzy find git-tracked files
- `<c-a>f` → `Telescope find_files` — fuzzy find all files in cwd
- `ml` → jump to mark `l` (used to restore position after opening pickers)

OS-specific file-manager, terminal, shell, and helper mappings live in `mappings_win.vim` and `mappings_mac.vim`; the large majority remains in `mappings.vim`. Plugin-specific OS settings follow the same convention in `pluginSettings_win.vim` and `pluginSettings_mac.vim`.

### `math.vim` — LaTeX/math editing
All TeX-specific mappings and functions. Loaded for `filetype=tex`. Contains:
- `<M-b>` insert mode shortcuts for Greek letters (`\alpha`, `\beta`, …)
- `<M-d>` shortcuts for math constructs (fractions, integrals, etc.)
- `Finmath` / `Foutmath` / `Noutmath` — search helpers that skip/target math zones
- `Joinmath` / `Joinmath2` — merge inline math fragments with `\text{}`
- vimtex integration mappings

### `env/editors/vim/manage_plugins.vim` — plugin manager shim
Provides the `Plugit` command. On **nvim**: converts vim-plug-style calls to lazy.nvim specs (collected in `LazyPlugSpecs`). On **vim**: delegates to vim-plug. Also provides `UnPlug`, `IsPluginUsed`, `MakeLazyKeys`.

### `myinit.lua` — Lua init / plugin setup
Sourced after plugins load. Contains:
- `GotoMap(key)` — jumps to the file+line where a keymap was defined (uses `verbose nmap`)
- `BufIsBig(bufnr)` — global helper (>100KB = big); used by cmp.lua and lspconfig.lua to skip large files
- `set_workspace_dir(dir)` — sets exactly one LSP workspace folder
- `PrintLspCapabilities(name)` / `PrintLspConfig(name)` — LSP debug helpers
- `tprint(tbl)` — pretty-print a Lua table
- **nvim-tree** full setup with custom keymaps (`mt` open tree at cwd, `X` delete, `dd`/`yy` cut/copy, `cd` change cwd, `/` fuzzy find via Fin, `<left>`/`<right>` navigate root, `S` cycle sort)
- **Telescope** setup (live-grep-args extension, `<esc>` closes in insert mode, `<c-j/k>` for selection)
- **which-key**, **lightspeed**, **navbuddy** setup calls
- `BufEnter` autocmd that writes the current buffer path to `c:\temp\active_buffer` (used by Claude Code to find the active file)
- `vim.lsp.set_log_level("debug")` — LSP logging is on

### `env/editors/vim/runtimepath/lua/config/lazy.lua` — lazy.nvim bootstrap
Initializes lazy.nvim. Key parts of `spec`:
- `{ "LazyVim/LazyVim", import = "lazyvim.plugins" }` — LazyVim base (disabled in `liteMode`)
- `{ import = "plugins" }` — loads all files in `myplugins/` as lazy specs
- `LazyPlugSpecs` — collected from `newplug_.vim` via `Plugit`

---

## `myplugins/` — lazy.nvim plugin configuration folder

Each file returns a lazy.nvim spec table (or a list of specs). These are auto-imported as `{ import = "plugins" }`.

| File | What it configures |
|------|-------------------|
| `lspconfig.lua` | Mason + mason-lspconfig + nvim-lspconfig + none-ls + none-ls-autoload. See LSP section below. |
| `cmp.lua` | nvim-cmp completion: sources (buffer, path, nvim_lsp), mappings, large-buffer auto-disable |
| `avante.lua` | Avante AI assistant (Claude/Grok providers). Build: `Build.ps1` on Windows |
| `lazyplugs.lua` | "Lazy way" to add plugins that don't need complex config: diffview, fzf-lua, lualine, snacks.nvim, auto-save, claudecode.nvim, gp.nvim, actions-preview, telescope-frecency, etc. |
| `minuet.lua` | minuet-ai inline completion (currently `enabled=false`) |
| `noice.lua` | Noice UI (command line / notification UI) |
| `repmo.lua` | repmo (repeat motions) |
| `check_servers.lua` | Debug helper — not a plugin spec. Run with `:lua dofile(...)` to inspect active LSP clients |

---

## LSP setup (`myplugins/lspconfig.lua`)

- Mason bin dir is prepended to `PATH` so lspconfig can find Mason-installed executables
- `mason_lspconfig.setup({ automatic_enable = { exclude = {...} } })` — listed servers use manual `lspconfig.server.setup()`, all others get auto-enabled
- **To add a server with custom config**: add to the `exclude` list + add `lspconfig.myserver.setup({...})`
- **To add a server with default config**: just `:MasonInstall servername`, no code needed

### Python LSP — intentional multi-server split

Three servers run simultaneously on Python, each with restricted capabilities:
- `jedi_language_server` — completions only (hover + symbols disabled)
- `pylsp` — pycodestyle/pylint/pydocstyle off; hover + document/workspace symbols disabled
- `pyright` — completions disabled; type analysis only

Do not "fix" the disabled capabilities — the split is deliberate to avoid duplicates.

---

## Neovim commands

```
:Lazy install        " install missing plugins  (abbrev: packi)
:Lazy update         " update plugins           (abbrev: packu)
:MasonInstall <name> " install an LSP server binary
:lua dofile('C:/Users/ekarni/.vim/myplugins/check_servers.lua')  " debug LSP clients
```
