# .vim


* fuzzyness all around! 

* Many useful functions and mappings. 

* Some unique functions for math. 
 
This document provides comprehensive documentation for the custom Vim configuration defined in `mappings.vim` and `hacks.vim`.

## Table of Contents

1. [Core Functions](#core-functions)
2. [Navigation & Movement](#navigation--movement)
3. [Insert Mode Mappings](#insert-mode-mappings)
4. [Leader Key Mappings](#leader-key-mappings)
5. [Function Keys](#function-keys)
6. [Search & Find](#search--find)
7. [Git Integration](#git-integration)
8. [Window & Buffer Management](#window--buffer-management)
9. [Text Manipulation](#text-manipulation)
10. [Python & REPL Integration](#python--repl-integration)
11. [Fuzzy Finding (FZF/Leaderf)](#fuzzy-finding-fzfleaderf)
12. [Utility Functions](#utility-functions)
13. [Math Support](#math-support)
14. [Operator Motions](#operator-motions)
15. [Ctrl-A Prefix - Fuzzy Finding & Navigation](#ctrl-a-prefix---fuzzy-finding--navigation)

---

## Core Functions

### Window & Buffer Tracking

#### `SaveLastWindow()`
- Tracks the last visited window across buffers
- Ignores terminal buffers and empty buffers
- Stores window history in `g:lastWindows`

#### `LastWindow()`
- Opens the last visited window in a vertical split
- **Command:** `:LastWindow`

### Directory Tracking

#### `LoadDir()`
- Loads cached directory list from `dirs.cache`
- Uses Python pickle for serialization

#### `SaveLastDir()`
- Tracks visited directories automatically
- Prevents duplicate entries
- Saves to `dirs.cache`

### Text Manipulation Utilities

#### `GL(arg)` - Global Line Processor
- Powerful text transformation function
- **Syntax:** `:GL /pattern/mode command`
- **Modes:**
  - `rpy` - Run Python and replace
  - `py` - Run Python and append
- **Example:** `:GL /\d\+/rpy match*2` (doubles numbers)

#### `Matches(pat)` - Pattern Matcher
- Searches current buffer for pattern
- Populates quickfix list with matches
- **Variants:**
  - `M pattern` - Case-sensitive match
  - `MC pattern` - Case-insensitive match
  - `MW pattern` - Word boundary match
- **Commands:**
  - `:M <pattern>` - Match pattern
  - `:MC <pattern>` - Case-insensitive match
  - `:MW <pattern>` - Word match
  - `:VG <pattern> [files]` - Vimgrep across files

### File Operations

#### `DeleteMe()`
- Deletes current file and buffer with confirmation
- **Command:** `:DeleteMe`

#### `MoveMe([destination])`
- Moves/renames current file
- **Command:** `:MoveMe [path]`
- Interactive if no argument provided

---

## Navigation & Movement

### EasyMotion Integration

#### Single Character Motion
- **`<c-]>`** - Search forward (Lightspeed_s)
- **`<c-[>`** - Search backward (Lightspeed_S)
- **`<M-f>`** - Two-character search
- **`<M-t>`** - Till character (QuickScope enhanced)
- **`?`** - Single line search

#### Word/Line Motion
- **`<c-h>`** - End of word bidirectional
- **`<M-h>`** - End of word left
- **`<M-d>`** - Beginning of word left
- **`mL`** - Line bidirectional jump

#### Find Enhancement (Insert & Normal Mode)
- **`<c-/>`** - Enhanced f (forward to char)
- **`<M-/>`** - Enhanced T (backward till char)
- **`<c-'>`** - Enhanced t (forward till char)
- **`<m-'>`** - Enhanced F (backward to char)
- **`f`** / **`F`** - QuickScope-enhanced find

### Quote & Bracket Navigation

#### `<Plug>NextQ` & `<Plug>PrevQ`
- **`&`** - Jump to next quote/string
- **`<c-7>`** - Jump to previous quote/string
- **`<c-5>`** - Next block (z%)

### Underscore Prefix Mappings

**Quick Navigation:**
- **`_u`** - Last window
- **`_U`** - Telescope last windows (if configured)
- **`_.`** - Change directory up (..)
- **`_-`** - Change to previous directory
- **`_t`** - Last tab
- **`_b`** / **`_B`** - Next/Previous buffer
- **`_P`** / **`_N`** - Previous/Next window

**Diff Operations:**
- **`_g`** - Diff get
- **`_p`** - Diff put
- Visual mode: **`_g`** / **`_p`** work on selection

**Other:**
- **`_f`** - LSP format
- **`_wo`** - Workspaces open
- **`_#`** - Alternative buffer

---

## Insert Mode Mappings

### Movement in Insert Mode

#### Arrow Keys Enhancement
- **`<M-Left>`** - Word backward (B)
- **`<M-Right>`** - Word forward (W)
- **`<M-Up>`** - Backspace
- **`<M-Down>`** - Word jump

#### Character Movement
- **`<m-h>`** / **`<m-j>`** / **`<m-k>`** / **`<m-l>`** - Vim direction keys

### Special Insert Functions

#### `StartSpecialInsert()`
- Activates timed insert mode
- Auto-exits after inactivity
- **Trigger:** `<Insert>` key in normal mode, `<F12>`, `<F13>`

### Character Insertion

#### `InsertBefore(count)` & `InsertAfter(count)`
- **`s`** - Insert character before cursor
- **`S`** - Insert character after cursor
- **`(`** - Insert character before (alternative)
- **`)`** - Insert character after (alternative)

### Completion

#### Enhanced Completion
- **`<c-k>`** - Recall inserts or navigate completion
- **`<c-b>`** - Get all inserts
- **`<c-f>`** - Keyword completion
- **`<c-z>`** - Smart completion (context-aware)
- **`<c-.>`** - Fuzzy completion info
- **`<m-f>`** - Path completion
- **`<m-c-k>`** - Dictionary completion

#### Copilot Integration
- **`<c-j>`** - Accept Copilot suggestion
- **`<M-j>`** - Next Copilot suggestion

### Insert Mode Utilities
- **`<c-l>`** - Undo
- **`<c-w>`** - Delete word backward
- **`<c-a>`** - Increment number
- **`<c-;>`** - Repeat last motion
- **`<M-Space>`** / **`<S-CR>`** - Normal mode command
- **`<c-i>`** - Paste formatted

---

## Leader Key Mappings

### File Operations

- **`<leader>of`** - Open file (split)
- **`<leader>og`** - Open file with fuzzy find
- **`<leader>OF`** - Open MRU in split
- **`<leader>ov`** - Open newplug.vim
- **`<leader>om`** - Open mappings.vim
- **`<leader>OM`** - Open mappings.vim in split
- **`<leader>on`** - Open myinit.lua
- **`<leader>ON`** - Open myinit.lua in split

### Window Management

- **`<leader>oc`** - Open quickfix
- **`<leader>ol`** - Open location list
- **`<leader>W`** - Set wrap

### Messages & Diagnostics

- **`<leader>em`** - Show messages (Noice or manual)
- **`<leader>EM`** - Noice telescope
- **`<leader>XF`** - LSP diagnostics (location list, filtered)
- **`<leader>xf`** - LSP diagnostics (quickfix, git only, filtered)

### Auto-save & Settings

- **`<leader>as`** - Toggle buffer auto-save
- **`<leader>AS`** - Toggle global auto-save
- **`<leader>SI`** - Toggle save inserts
- **`<leader>rn`** - Toggle relative numbers

### Diff Operations

- **`<leader>do`** - Diff off
- **`<leader>du`** - Diff update
- **`<leader>dt`** - Diff this
- **`<leader>g2`** - Diffget from buffer 2
- **`<leader>g3`** - Diffget from buffer 3

### Tab Navigation

- **`<leader>1`** - **`<leader>9`** - Jump to tab 1-9

---

## Function Keys

### F1 - Help
- **`<F1>`** - Help for word under cursor

### F2 - Execute
- **`<F2>`** - Execute current line as Vim command
- **`<S-F2>`** - Execute as Lua
- **`<F2>` (Visual)** - Execute selection as Vim command
- **`<S-F2>` (Visual)** - Execute selection as Lua
- **`<F6>` (Visual)** - Print Lua expression

### F3/F4 - REPL
- **`<F3>`** - Send line to REPL
- **`<F3>` (Visual)** - Send selection to REPL
- **`<F4>`** - Clear and run current file in REPL
- **`<F8>`** - Clear REPL

### F5 - Python Run
- **`<F5>`** - IPython run
- **`<S-F5>`** - Run file with `<leader>rf`

### F6-F8 - Line Manipulation
- **`<S-F6>`** - Delete line and paste 2 lines up
- **`<S-F7>`** - Yank and paste below
- **`<S-F8>`** - Delete and paste below

### F12/F13 - Special Insert
- **`<F12>`** / **`<F13>`** - Start special insert mode
- **`<F12>` (Insert)** - Single normal command
- **`<F13>` (Insert)** - Escape

---

## Search & Find

### Basic Search

#### Search Toggle
**Function:** `ToggleSearch()`
- **`mS`** - Toggle incremental search & highlight

#### Search Configuration
- **`m/`** - Search forward (no ignorecase, no incsearch)
- **`m?`** - Search backward (with incsearch & hlsearch)

### Current File Search

#### Line Search
- **`,`** - Leaderf line search (popup)
- **`m,`** - Leaderf line with preview
- **`<m-,>`** - Telescope LSP symbols

#### Pattern Matching
- **`TT`** - Search word under cursor
- **`T` (Visual)** - Search visual selection
- **`Mm`** / **`MM`** - Search inner word/WORD
- **`Y` (Visual)** - Match selection in current file
- **`M` (Visual)** - Same as Y
- **`RR` (Visual)** - Search selection with `/`

### Multi-file Search

#### Leaderf Ripgrep
- **`L`** (Operator)** - Interactive ripgrep with motion
- **`L` (Visual)** - Ripgrep visual selection
- **`Ll`** / **`LL`** - Ripgrep inner word/WORD

#### FZF Integration
- **`<leader>gm`** - Go to mapping definition
- **`mge` (Visual)** - Exact ripgrep search
- **`MG`** - Lookup word in current file

### Search History
- **`<c-_>`** - Search with history
- **`<c-s>`** - Smart search (EasyMotion)
- **`<m-s>`** - Till search

---

## Git Integration (Fugitive)

### Basic Git Commands

#### Git Status & Commit
- **`mg`** - Git status (with custom git dir)
- **`mG`** - Standard Git status
- **`<leader>Gc`** - Git commit
- **`<leader>GC`** - Git commit --amend --no-verify
- **`<leader>Ga`** - Git add current file
- **`<leader>Gt`** - Git commit current file

#### Git Diff
- **`<leader>Gd`** - Git diff split
- **`<leader>GD`** - Git diff 3-way merge
- **`<leader>GDh`** - Git diff vs HEAD^
- **`<leader>Gs`** - Git diff --staged

#### Git Log
- **`<leader>Gl`** - Git log (all)
- **`<leader>GL`** - Git log (current file)

#### Git Operations
- **`<leader>Ge`** - Git edit
- **`<leader>Gr`** - Git read
- **`<leader>Gg`** - Git grep
- **`<leader>Gb`** - Git branch
- **`<leader>Go`** - Git checkout

#### Git Push/Pull
- **`<leader>Gp`** - Git push
- **`<leader>GP`** - Git push --force
- **`<leader>Gu`** - Git push upstream
- **`<leader>GU`** - Git push -f upstream

#### Git Merge
- **`<leader>Gmo`** - Merge with ours strategy
- **`<leader>Gmt`** - Merge with theirs strategy

### GitGutter Navigation
- **`[h`** - Previous hunk
- **`]h`** - Next hunk

### Custom Git Functions

#### `GCWD` Command
- Git commands in current working directory
- **Usage:** `:GCWD [git-command]`

---

## Window & Buffer Management

### Buffer Navigation

#### Buffer List
- **`|`** (bar) - Leaderf buffer list (all)
- **`m|`** - Leaderf buffer list (current tab)
- **`<M-Bslash>`** - Buffer list (no jump to existing)

#### Quick Buffer Actions
- **`_b`** / **`_B`** - Next/Previous buffer
- **`_#`** - Alternative buffer

### Window Operations

#### Window Creation
**Function:** `VspIfNeed()`
- Creates vertical split if none exists
- Otherwise jumps to existing right window

#### Window Navigation
- **`_P`** / **`_N`** - Previous/Next window
- **`mo`** - Close splits & open buffer list
- **`mO`** - Close splits & open all buffers OR swap windows

#### Window Management
**Function:** `CloseAllWindowsButCurrent()`
- Closes all windows except current
- Handles NvimTree specially

**Function:** `CloseVspIfNeed()`
- Intelligently closes rightmost split
- Recursive cleanup

### Tab Management

#### Tab Navigation
- **`<leader>1-9`** - Jump to tab 1-9
- **`_t`** - Last tab

#### Tab Commands
**Command:** `TN [file]`
- Opens file in existing tab if open
- Otherwise creates new tab

### NvimTree
- **`mt`** - Toggle NvimTree (defined in Lua)
- **`MT`** - Open NvimTree at current file location
- **Function:** `CloseAllNR()` - Close all netranger windows

---

## Text Manipulation

### Surround Operations

#### Add Surround
- **`m'`** - Surround word with single quotes
- **`m{`** - Surround word with braces
- **`m[`** - Surround word with brackets
- **`m(`** - Surround word with parentheses

### Paste Operations

#### Smart Paste
**Function:** `PasteFormat(x)`
- **`]p`** / **`]P`** - Smart paste (formats based on content)
- Handles newlines intelligently

#### Special Paste
**Function:** `MPf()` & `Domp()`
- **`mp`** - Paste on new line with formatting
- **`mP`** / **`MP`** - Paste without newlines
- **`mP` (Visual)** - Paste over selection

### Line Manipulation

#### Create/Delete Lines
- **`mn`** - Create new empty line below

#### Copy Operations
- **`mY`** - Yank line without newline
- **`mC`** - Copy file path to clipboard

### Whitespace Cleanup

#### Whitespace Functions
- **`msA`** - Remove all leading/trailing spaces & empty lines (file)
- **`msa`** - Remove all leading/trailing spaces & empty lines (line)
- **`msb`** - Remove trailing spaces & empty lines (file)
- **`mss`** - Remove multiple spaces (line)
- **`msl`** - Remove trailing spaces (file)
- **`msc`** - Remove trailing spaces preserving text (file)

### Format Operations

#### Python Formatting
**Function:** `AlignWithTopLine()`
- Aligns selection with line above
- Python-aware indentation

**Function:** `ConditionalAlign()`
- Python: Uses autopep8
- Others: Standard Vim format

**Function:** `FormatCurrentBlock()`
- Formats current Python block
- **`<plug>fff`** - Format block (can be mapped to ==)

### Text Transformation

#### Case Operations
**Function:** `ReplaceCasing(word, oldword)`
- Smart case-insensitive replace

#### Create List
**Function:** `CreateList()`
- **Command:** `:CL` (visual mode)
- Converts lines to quoted list items

#### Windows Line Endings
- **`mwin`** - Convert Windows line endings

---

## Python & REPL Integration

### IPython Integration

#### IPython Commands
- **`<M-r>`** - Run Python command (input)
- **`<M-k>`** - Word object info
- **`<M-g>`** (Insert) - IPython complete

#### Run Current File
- **`<leader>rf`** - Run current file (Python: %run, PS1: custom)
- **`<leader>rb`** - Interrupt IPython
- **`<leader>rt`** - Terminate IPython
- **`<leader>rc`** - Run cell

### REPL Functions

#### `TermO()` / `TermOV()` / `TermLOV()`
- **`<leader>ot`** - Terminal in new tab
- **`<leader>tt`** - Terminal in vertical split (CWD)
- **`<leader>Tt`** - Terminal in vertical split (file dir)
- **`<leader>gt`** - WSL terminal in vertical split

### Debugging

#### Python Debugger
- **`<leader>mb`** - Insert ipdb breakpoint

#### Vimspector
- **`<leader>vl`** - Launch debugger
- **`<leader>vr`** - Reset debugger
- **`<leader>vs`** - Stop debugger
- **`<leader>vR`** - Restart debugger
- **`<leader>vp`** - Pause debugger

#### JSON Creation
**Function:** `MakeJson([override])`
- Creates .vimspector.json for Python debugging

---

## Fuzzy Finding (FZF/Leaderf)

### Ctrl-A Prefix Mappings

#### Files & Directories
- **`<c-a>f`** - Files in CWD (FzfLua)
- **`<c-a>F`** - Files in current file's directory (Telescope/Leaderf)
- **`<c-a>d`** - Change directory (from cache, with mark)
- **`<c-a>D`** - Change directory (from cache, no mark)

#### Search
- **`<c-a>g`** - Interactive ripgrep
- **`<c-a>G`** - Live grep
- **`<c-a>l`** - All inserts (current buffers)
- **`<c-a>L`** - Lines in all buffers
- **`<c-a>a`** - Ag search

#### Navigation
- **`<c-a>b`** - Windows
- **`<c-a>w`** - Tabs
- **`<c-a>j`** - Jumplist (Telescope)
- **`<c-a>h`** - File history
- **`<c-a>H`** - Bash history

#### Recall & Commands
- **`<c-a>r`** - Leaderf recall
- **`<c-u>`** - Same as `<c-a>r`
- **`<c-a>R`** - Leaderf Rg recall
- **`<c-a>c`** - Command history
- **`<c-a>C`** - Commands
- **`<c-a>m`** - Mappings (keys only)
- **`<c-a>M`** - Mappings (with descriptions)
- **`<c-a>s`** - Snippets

### MRU (Most Recently Used)

- **`mm`** - Leaderf MRU (fuzzy)
- **`mM`** - MRU (ordered)
- **`M,`** - CtrlP
- **`m.`** - CtrlP (clear cache)

### Command-line Completion

#### `CompleteCommand(arg)`
- **`<c-a>` (Command)** - Complete from command history
- **`<c-b>` (Command)** - Edit in command window

### Quick File Open

- **`<c-p>`** - Change dir & open file
- **`<m-p>`** - Open in vertical split
- **`<m-o>`** - Open with FZF
- **`<m-'>`** - Open in git root
- **`<c-b>`** - Close splits & open buffer

### Help Search

- **`mH`** - Leaderf help
- **`Mh`** / **`MH`** - Standard help
- **`<m-k>`** (Normal)** - Leaderf help for word
- **`<m-k>` (Visual)** - Leaderf help for selection

---

## Utility Functions

### Mark Operations

#### Auto-marks
- **`.`** - Last change
- **`mI`** - Last insert position
- **`mM`** - Last modification
- **`mH`** - Search mark (<c-f>)
- Mark tracking functions in hacks.vim:266-269

#### Mark Navigation
- **`<leader>.`** - Jump to last change
- **`<leader>'`** - Jump to last position
- **`mb`** / **`mB`** / **`mv`** - Jump list navigation

### Register Operations

#### Register Inspection
**Function:** `MapR()`
- **`R{char}`** - Show register content
- **`<M-0>` to `<M-9>`** - Show numbered registers
- **`<M-->`** / **`<M-=>`** - Show + and = registers

### Timer Functions

#### `TimerFunc(a)` & `TimerFuncB(a)`
- Auto-save workspace
- Clipboard synchronization
- Runs periodically in background

### Helper Functions

#### `MinExec(cmd)`
- Executes command and returns output as string

#### `Exec(cmd)`
- Executes command and opens result in new tab

#### `GetVisualSelection()`
- Returns current visual selection as string

#### `CopyPath()`
- Copies current file path to clipboard
- **Mapped to:** `mC`

#### `Tailf()`
- **Command:** `:Tailf`
- Continuously reloads and shows end of file

### PowerShell Integration

#### `TogglePS()` & `RunPS(var)`
- Switch between PowerShell and default shell
- **`P <cmd>`** - Run PowerShell command
- **`TP`** - Toggle PowerShell mode

### Quickfix/Location List

#### Navigation
**Functions:** `Goprev()` & `Gonext()`
- **`<S-F3>`** - Previous item
- **`<S-F4>`** - Next item
- Auto-detects quickfix vs location list

#### Diagnostics
**Function:** `DiagnosticsGitOnly()`
- Filters diagnostics to git-tracked files only
- **`<leader>xf`** - Execute with filter

### Miscellaneous

#### Undo Tree
- **`mu`** - Toggle UndoTree

#### Workspace Management
- **`mws`** - Save CtrlSpace workspace
- **`mwd`** - Save default workspace

#### Comment Toggle
- **`__`** - Comment out (vim-commentary)
- **`_+`** - Uncomment

#### Translation
- **`<c-t>` (Visual)** - Translate selection

#### Fold Management
- **`mf`** - Open file directory
- **`mF`** - Execute function under cursor

#### Diff/Compare
- **`md`** - Diff update

#### Redraw
- **`<leader>rd`** - Force redraw (Ctrl-L)

#### Path Operations
- **`gp`** - Edit file under cursor in pycharm (translated path for Windows)
- **`mc`** - Change directory to current file

#### Special
- **`mj`** - Clear search highlight
- **`<c-CR>`** - Clear highlight & dismiss Noice
- **`<Home>`** - Go to first non-blank character
- **`x`** - Delete without copying (black hole register)

---

## Advanced Features

### Insert Tracking System

#### Insert Functions
**Defined in:** inserts.vim (sourced from hacks.vim:4)

**Functions:**
- `AddInsert(text)` - Add text to insert cache
- `RecallInserts(mode)` - Recall from insert cache
- `GetAllInserts()` - Get all inserts (FZF)
- `EnableTrackInserts(enable)` - Toggle tracking

**Related:**
- `SaveInsertsFunc(a)` (hacks.vim:84) - Persists inserts
- Insert cache stored per-file in `b:inserts`

### Completion System

#### `DoCz()` Function
- Smart completion behavior
- Handles keyword vs other completion
- **`<c-z>`** (Insert) - Invoke smart complete

#### `CompleteInf()` Function
- FZF-based completion with preview
- **`<c-.>`** (Insert/Command) - Fuzzy complete anything

### Special Search Functions

#### `SpecialFindLeader(type)` & `SpecialFindRg(type)`
- Operator-pending motions for search
- `L{motion}` - Ripgrep with motion
- `M{motion}` - LeaderfLine with motion

### File Type Specific

#### Python
- Auto-indentation with autopep8
- IPython integration
- Debugging support

#### PowerShell
- Custom terminal setup
- RunPS integration

---

## Configuration Variables

### Global Variables

#### Directories & Paths
- `g:vimloc` - Vim configuration directory
- `g:dirs` - Cached directories list
- `g:lastWindows` - Window history
- `g:lastWinName` - Last window name
- `g:lastdir` - Last directory

#### Behavioral
- `g:init` - Initialization flag
- `g:pwmod` - PowerShell mode flag
- `g:on_ek_computer` - Machine-specific flag
- `g:special_insert` - Special insert mode flag
- `g:detect_mod_reg_state` - Register change detection

#### Timers
- `g:autosaveWS` - Auto-save workspace timer
- `g:timerb` - Clipboard sync timer
- `g:inactivity_limit` - Special insert timeout
- `g:check_frequency` - Check interval

#### Shell Configuration
- `g:sh`, `g:shf`, `g:shr`, `g:shq`, `g:shxq`, `g:shellpipe` - Shell settings backup

### Buffer-local Variables

- `b:save_inserts` - Enable insert tracking per buffer
- `b:auto_save` - Enable auto-save per buffer
- `b:inserts` - Insert cache per buffer
- `b:git_dir` - Git directory override

---

## Auto Commands

### Tracking
- `BufWinLeave` - SaveLastWindow()
- `DirChanged` - SaveLastDir()
- `TextYankPost` - SaveLastReg()
- `CursorMoved` - DetectRegChangeAndUpdateMark()

### Insert Tracking
- `InsertEnter` - CheckSpecialInsert()
- `InsertLeave` - EndSpecialInsert(), auto-mark
- `TabLeave` - Save last tab number

### File Type
- `FileType *` - Set up Lightspeed mappings with IsRegular() check

### Cleanup
- `ExitPre` - StopTimerFunc()

---

## Custom Commands Reference

### Text Processing
- `:GL /pattern/mode command` - Global line processing with Python
- `:M <pattern>` - Match pattern in current buffer
- `:MC <pattern>` - Case-insensitive match
- `:MW <pattern>` - Word match
- `:VG <pattern> [files]` - Vimgrep across files
- `:MESC <pattern>` - Match with full regex
- `:CL` - Create list from visual selection

### File Operations
- `:TN [file]` - Tab new (reuse existing)
- `:LastWindow` - Open last window
- `:DeleteMe` - Delete current file
- `:MoveMe [path]` - Move/rename current file

### Utilities
- `:Tailf` - Tail -f current file
- `:P <cmd>` - Run PowerShell command
- `:TP` - Toggle PowerShell mode
- `:Filter <cmd> [delete]` - Filter file through command
- `:GCWD [git-cmd]` - Git command in CWD

### Git (Fugitive)
- All standard Fugitive commands
- Custom `:GCWD` variant

### Debugging
- `:PyRun` - Run Python with IPython completion

---

## Tips & Tricks

### Quick Patterns

1. **Search current word in all files:** `Ll` or `LL`
2. **Open recent file:** `mm`
3. **Switch between last two tabs:** `_t`
4. **Copy file path:** `mC`
5. **Clean up whitespace:** `msA` (all) or `msa` (current line)
6. **Smart paste:** `]p` or `]P`
7. **Navigate quickfix:** `<S-F3>` / `<S-F4>`
8. **Open terminal:** `<leader>tt`
9. **Format Python block:** Use `<plug>fff`
10. **Recall insert history:** `<c-k>` in insert mode

### Workflow Examples

#### Python Development
1. Open file with `<c-p>`
2. Set up IPython terminal with `<leader>tt`
3. Send code to REPL with `<F3>`
4. Run entire file with `<leader>rf`
5. Debug with `<leader>mb` (set breakpoint) and `<leader>vl` (launch)

#### Git Workflow
1. Check status with `mg`
2. Stage file with `<leader>Ga`
3. Commit with `<leader>Gc`
4. Push with `<leader>Gp`
5. View diff with `<leader>Gd`

#### Text Search & Replace
1. Search in current file: visual select + `Y`
2. Search in project: visual select + `L`
3. Filter results: use quickfix commands
4. Replace: use `:cdo` or standard substitute

---

## Notes

- Many functions require specific plugins (Leaderf, FZF, Telescope, etc.)
- Some mappings use `<Plug>` which requires the corresponding plugin
- The configuration heavily uses Python (Python 2 and 3) for certain features
- Timer functions run in background for auto-save and clipboard sync
- Special insert mode provides timed insert with auto-exit
- The system tracks inserts, windows, and directories for quick access
- Git integration requires vim-fugitive
- EasyMotion and Lightspeed are used extensively for navigation

---

## File Structure

- **hacks.vim**: Core functions, utilities, tracking systems
- **mappings.vim**: All key mappings, leader mappings, function keys
- **inserts.vim**: Insert tracking system (sourced)
- **Other files**: Referenced but not documented here (myinit.lua, newplug.vim, etc.)

---

## Math Support

### LaTeX Integration
- vim-tex support
- Math snippets taken from https://castel.dev/post/lecture-notes-1/

### Greek Letters
- **`~{letter}`** - Insert greek letters
  - Example: `~a` for alpha

### Math Operators
- **`@{char}`** - Insert math operators
  - Example: `@c` for `\mathcal{}`

### Math Functions
- **`<cmd>+<d>`** - Math functions (same as LyX bindings)
- **`<cmd>+<b>`** - Letter formatting
- Works in both insert and normal mode
- Note: Requires Vim GUI that supports `<d->` for cmd key

---

## Operator Motions

### Custom Text Objects

#### H Operator - Head
- Operates on the beginning/head portion of text
- Use with motions to select from start to motion point

#### L Operator - Line Text Object
- **`L{motion}`** - Interactive ripgrep with motion
- Searches for text selected by motion across files
- **Usage Examples:**
  - `Liw` - Ripgrep inner word
  - `Li'` - Ripgrep text inside quotes
  - `Lip` - Ripgrep paragraph
- Related mappings:
  - `Ll` - Ripgrep inner word
  - `LL` - Ripgrep inner WORD
  - `L` (Visual) - Ripgrep visual selection

#### T Operator - Till Motion
- Enhanced till motion with operator support
- Works with text objects for precise selection

---

## Ctrl-A Prefix - Fuzzy Finding & Navigation

The `<c-a>` prefix provides quick access to fuzzy finding and navigation features. All mappings use FZF, Telescope, or Leaderf for fuzzy search.

### Files & Directories
- **`<c-a>f`** - Files in CWD (FzfLua)
- **`<c-a>F`** - Files in current file's directory (Telescope/Leaderf)
- **`<c-a>d`** - Change directory (from cache, with mark)
- **`<c-a>D`** - Change directory (from cache, no mark)
- **`<c-a>h`** - File history (MRU)

### Search Operations
- **`<c-a>g`** - Interactive ripgrep (text in files)
- **`<c-a>G`** - Live grep
- **`<c-a>l`** - All inserts (lines in current buffer)
- **`<c-a>L`** - Lines in all open buffers
- **`<c-a>a`** - Ag search

### Navigation
- **`<c-a>b`** - Windows (also available as `|`)
- **`<c-a>w`** - Tabs
- **`<c-a>j`** - Jumplist (Telescope)

### Commands & History
- **`<c-a>c`** - Command history (`:` commands)
- **`<c-a>C`** - All defined commands
- **`<c-a>H`** - Bash history
- **`<c-a>r`** - Leaderf recall (also `<c-u>`)
- **`<c-a>R`** - Leaderf Rg recall

### Mappings & Help
- **`<c-a>m`** - All custom key mappings (search by shortcut key)
- **`<c-a>M`** - All mappings (full text search with descriptions)

### Snippets & Completions
- **`<c-a>s`** - Snippets (UltiSnips)

### Related Mappings
- **`<M-Bslash>`** - Window titles (navigate between windows)

