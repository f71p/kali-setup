# Cheat sheet

Daily reference for everything this playbook sets up. Keys are written as `Ctrl+A`, `Win+F`, etc.
In tmux, **prefix** means `Ctrl+A` (press, release, then the next key).

- [My scripts](#my-scripts)
- [Shell (zsh)](#shell-zsh)
- [tmux](#tmux)
- [kitty](#kitty)
- [Neovim](#neovim)
- [yazi](#yazi)
- [Desktop (XFCE) and VMware](#desktop-xfce-and-vmware)
- [This playbook](#this-playbook)

---

## My scripts

All support `-h`.

| Command | Does |
|---|---|
| `extract file.zip` | Unpacks any archive (zip, tar.*, 7z, rar, deb, rpm, iso, cab) into `file/`. Several at once: `extract *.zip` |
| `cmd \| clip` | Copies output to the clipboard (reaches Windows). `clip file` copies a file. `clip` alone prints the clipboard |
| `rec [label]` | Records the terminal to `$LOGS/<date>/<time>_<label>.log` until `exit`. tmux shows **● REC** |
| `logcat file.log` | Shows a recording as plain text. Replay it live: `scriptreplay -T file.timing file.log` |
| `keys [search]` | Search every keybind and command in this cheat sheet as you type. `keys copy` starts with "copy" typed in |
| `fetch` | System info with the animated Kali logo. Runs by itself in each new kitty window (not in tmux panes) |
| `fetch-logo` | Rebuilds the logo GIF, e.g. after changing the kitty background (`FETCH_LOGO_BG='#000000' fetch-logo`) |
| `timesync <dc>` | Clock on the DC's time (Kerberos "clock skew too great"). Undo: `timesync reset` |
| `y` | Opens yazi (file manager). Quitting with `q` leaves you in the folder you were in |
| `history -i 1` | Every command with date/time (`history -i -20` for the last 20) |

`$LOGS` = `~/logs`: a central place for recordings and anything else you want to keep, e.g. `cmd > $LOGS/out.txt`.

---

## Shell (zsh)

**Autosuggestions** (grey text after the cursor)

| Key | Does |
|---|---|
| `→` / `End` / `Ctrl+Space` | Accept the whole suggestion |
| `Ctrl+→` | Accept the next word |

**Completion and search**

| Key | Does |
|---|---|
| `Tab` | Fuzzy completion menu (type to filter, `<` `>` switch groups) |
| `cmd -` then `Tab` | Flags for any tool, read from its `--help` |
| `nxc smb -M` then `Tab` | NetExec: Tab after a protocol lists its modules (live from `nxc <proto> -L`); `-` then Tab lists that protocol's flags |
| `Ctrl+R` | Fuzzy search command history |
| `Ctrl+T` / `Ctrl+F` | Insert a file path (fuzzy, with a preview, images too), e.g. `cat ` then `Ctrl+F`. `Tab` marks several |
| `Alt+C` | cd into a folder (fuzzy) |
| `z <part>` | Jump to a frequently used folder (`z setup` → `~/Projects/setup`) |
| `zi` | Pick a frequent folder from a list |

**Editing the command line**

| Key | Does |
|---|---|
| `Ctrl+A` / `Ctrl+E` | Start / end of line (in tmux: `Ctrl+A` twice) |
| `Ctrl+U` | Delete to start of line |
| `Ctrl+W` | Delete previous word |
| `Ctrl+←` / `Ctrl+→` | Move by word |
| `Esc` `Esc` | Put `sudo` in front of the command (the last one if the line is empty); again to remove it |
| `Alt+.` | Type the last argument of the previous command (press again for older ones) |
| `Ctrl+Z` | Suspend a program (e.g. nvim); on an empty prompt, Ctrl+Z again brings it back |
| `Ctrl+P` | Toggle Kali's one-line / two-line prompt |

The time on the right of the prompt is when that command was run (Enter pressed), handy for reports.

**Nicer everyday commands**

| Command | Does |
|---|---|
| `tldr tar` | Short practical examples for a command (`tldr -l` lists pages) |
| `cat file` | Syntax-highlighted, otherwise plain. `bat file` adds line numbers and a pager; `command cat` is the original. Images (`cat pic.png`) are drawn in the terminal |
| `ll` / `la` / `l` | Long list with git status / include hidden / one per line (`ls` works as usual) |
| `lt` / `lt -L3 dir` | Tree view, 2 levels deep (`-L` for more) |
| `man cmd` | Man pages are coloured |
| `kitten diff a b` | Side-by-side diff with colours; works on folders and images too (`q` quits) |

`vim` runs Neovim. Start a command with a space to keep it out of history.

---

## tmux

Start: `tmux` · reattach: `tmux a` · list sessions: `tmux ls`

| Keys | Does |
|---|---|
| prefix `v` | Split side by side (new pane in same folder) |
| prefix `s` | Split stacked |
| prefix `h` `j` `k` `l` | Move between panes (or click with the mouse) |
| prefix `z` | Zoom pane full-window / back |
| prefix `x` | Close pane |
| prefix `Space` | Cycle pane layouts |
| prefix `c` | New window |
| prefix `1`–`9` | Go to window (numbered from 1) |
| prefix `n` / `p` | Next / previous window |
| prefix `,` | Rename window |
| prefix `w` | Tree of all sessions and windows |
| prefix `d` | Detach (everything keeps running; `tmux a` to return) |
| prefix `r` | Reload `~/.tmux.conf` |
| prefix `y` | Copy the last command and its output (same as `Ctrl+Shift+Y`) |
| prefix `,` | Rename the window. Otherwise tabs name themselves: the running program, or the folder when idle |
| prefix `\` | Floating terminal over the current pane; prefix `\` again hides it (what runs in it keeps going) |
| Mouse drag | Resize panes, select text (copies to clipboard on release) |

**Copy mode** (scroll back and copy): prefix `[`, or scroll up with the mouse wheel.

| Key | Does |
|---|---|
| `Ctrl+U` / `Ctrl+D` | Half page up / down |
| `g` / `G` | Top / bottom |
| `/` / `?` then `n` | Search down / up, next match |
| `Space` … `Enter` | Start selection … copy to clipboard |
| `v` | Toggle block (rectangle) selection |
| `q` | Leave copy mode |

Status bar: **● REC** while `rec` runs · VPN IP (green `tun0`, or grey `eth0`) · clock.

---

## kitty

Selecting text copies it automatically. Inside tmux/nvim, hold **Shift** while dragging to select with kitty instead.

| Keys | Does |
|---|---|
| `Ctrl+Shift+C` / `Ctrl+Shift+V` | Copy / paste |
| `Ctrl+Shift+T` / `Ctrl+Shift+Q` | New tab / close tab |
| `Ctrl+Shift+→` / `Ctrl+Shift+←` | Next / previous tab |
| `Ctrl+Shift+Enter` | New kitty window (split) |
| `Ctrl+Shift+=` / `-` / `Backspace` | Font bigger / smaller / reset |
| `Ctrl+Shift+H` | Scrollback in a pager (search with `/`) |
| `Ctrl+Shift+G` | Output of the last command in a pager |
| `Ctrl+Shift+Y` | Copy the last command and its output to the clipboard (works in tmux too) |
| `Ctrl+Shift+E` | Pick a URL on screen to open |
| `Ctrl+Shift+Z` / `Ctrl+Shift+X` | Jump to the previous / next command in the scrollback (not in tmux) |
| `Ctrl+Shift+G` | Show the last command's output in a pager (not in tmux) |
| `Ctrl+Shift+P` then `I` / `H` / `F` / `W` | Label every IP / hash / file path / word on screen; press a label to type it into the command line |
| `Ctrl+Shift+F11` | Fullscreen |
| `Ctrl+Shift+F5` | Reload `kitty.conf` |

---

## Neovim

Run `nvim file` (or `vim file`). **Leader** is `Space`. `Esc` gets you back to normal mode from anything.

**Modes**

| Key | Does |
|---|---|
| `i` / `a` | Insert before / after cursor |
| `I` / `A` | Insert at start / end of line |
| `o` / `O` | New line below / above, and insert |
| `v` / `V` / `Ctrl+V` | Select characters / lines / block |
| `:` | Command line |

**Saving and quitting**

| Key | Does |
|---|---|
| `Space w` | Save |
| `Space q` | Quit |
| `:wq` / `:q!` | Save and quit / quit without saving |
| `:e file` | Open another file |

**Moving**

| Key | Does |
|---|---|
| `h` `j` `k` `l` | Left, down, up, right (arrows work too) |
| `w` / `b` / `e` | Next word / back a word / end of word |
| `0` / `^` / `$` | Line start / first character / line end |
| `gg` / `G` / `42G` | First line / last line / line 42 |
| `Ctrl+D` / `Ctrl+U` | Half page down / up |
| `%` | Jump to matching bracket |
| `f x` / `t x` | Jump to / just before the next `x` on the line |

**Editing**

| Key | Does |
|---|---|
| `x` | Delete character |
| `dd` / `yy` / `p` | Delete (cut) line / copy line / paste below (`P` above) |
| `dw` / `cw` | Delete word / change word |
| `D` / `C` | Delete / change to end of line |
| `ci"` / `di(` | Change inside quotes / delete inside brackets (works with `'` `(` `[` `{` `<`) |
| `u` / `Ctrl+R` | Undo / redo (undo survives closing the file) |
| `.` | Repeat last change |
| `>` / `<` (selection) | Indent / unindent (selection stays) |
| `gcc` / `gc` (selection) | Comment / uncomment |
| `J` | Join line below onto this one |

Prefix a number to repeat: `5dd` deletes 5 lines, `3w` moves 3 words.

**Clipboard and mouse**: every yank/delete goes to the system clipboard (and to Windows). Dragging with the mouse selects *and* copies. `p` pastes from the clipboard.

**Search and replace**

| Key | Does |
|---|---|
| `/text` then `n` / `N` | Search forward, next / previous match (case-insensitive unless you type a capital) |
| `*` | Search for the word under the cursor |
| `Esc` | Clear search highlight |
| `:%s/old/new/g` | Replace everywhere (`/gc` to confirm each) |

**Files, splits and buffers**

| Key | Does |
|---|---|
| `Space e` | File browser (`Enter` open, `-` up a folder, `%` new file, `d` new folder, `D` delete, `R` rename) |
| `:vsp file` / `:sp file` | Split side by side / stacked |
| `Ctrl+H` `J` `K` `L` | Move between splits |
| `:bn` / `:bp` / `:ls` | Next / previous / list open files |

---

## yazi

Open with `y` (or `y some/folder`). `~` or `F1` shows every key.

| Key | Does |
|---|---|
| `h` `j` `k` `l` / arrows | Parent folder, down, up, open folder |
| `Enter` / `o` | Open file (text opens in nvim) |
| `q` / `Q` | Quit and cd to here / quit and stay where you started |
| `gg` / `G` | Top / bottom |
| `H` / `L` | Back / forward in folder history |
| `.` | Show / hide hidden files |
| `z` | Find a file with fzf |
| `Z` | Jump to a frequent folder (zoxide) |
| `s` / `S` | Search file names (fd) / file contents (ripgrep) |
| `/` then `n` `N` | Find in the current folder |
| `f` | Filter the list |
| `Space` / `v` / `Ctrl+A` | Select file / visual select / select all |
| `y` / `x` / `p` | Copy / cut / paste |
| `d` / `D` | Move to trash / delete permanently |
| `a` | New file (end the name with `/` for a folder) |
| `r` | Rename |
| `cc` / `cd` / `cf` | Copy file path / folder path / file name |
| `;` | Run a shell command here |
| `gh` / `gd` | Go home / to Downloads |
| `tt` / `1`–`9` | New tab / switch tab |
| `J` / `K` | Scroll the preview |

Images and PDFs preview in the right pane, including inside tmux.

---

## Desktop (XFCE) and VMware

| Keys | Does |
|---|---|
| `Win+Enter` | Open kitty |
| `Win+Space` | App launcher (type, `Enter`) |
| `Win+←` / `Win+→` | Snap window to left / right half |
| `Win+F` | Toggle fullscreen |
| `Win+Backspace` | Close window (`Alt+F4` also works) |
| `Ctrl+Alt+1`–`4` | Switch workspace |
| `Win+Shift+1`–`4` | Move window to workspace |
| `Win+E` | File manager |
| `Win+D` | Show desktop |
| `Print` / `Shift+Print` | Screenshot: screen / region (add `Ctrl` to copy to clipboard instead) |
| `Alt+F2` | Run a command |

`Win+L` and `Win+1`–`9` are taken by Windows, so they don't reach the VM. kitty is the default terminal everywhere (file manager, panel).

**VMware**

| Command | Does |
|---|---|
| `ls /mnt/hgfs/` | Shared folders (mounted automatically at boot) |
| `sudo mount-shared-folders` | Mount shares added while the VM is running |
| `restart-vm-tools` | Fix copy/paste or resizing when VMware Tools misbehaves (then reopen kitty/tmux if the terminal still won't copy) |
| `pgrep -a autocutsel` | Should list two: they make terminal copies reach Windows. If missing: `autocutsel -fork; autocutsel -selection PRIMARY -fork` (see README) |

---

## This playbook

Repo: `~/Projects/setup` (public: github.com/f71p/kali-setup)

| Command | Does |
|---|---|
| `./bootstrap.sh` | Apply everything |
| `./bootstrap.sh --tags dotfiles` | Re-apply configs after editing `configs/` |
| `./bootstrap.sh --tags apt,pipx` | Install tools after editing `packages/*.txt` |
| `./bootstrap.sh --check --diff` | Dry run |

**Adding things**: apt package → `packages/apt.txt` · Python tool → `packages/pipx.txt` · binary from GitHub → `packages/github-releases.txt` · config file → `configs/home/` (mirrors `~`) · zsh setting/alias → new file in `configs/home/.zshrc.d/`.

Edit configs in the repo, not in `~` (the playbook overwrites `~`, keeping a timestamped backup). The repo is **public**: no passwords, keys or VPN files.
