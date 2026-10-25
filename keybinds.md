
# Felipe's Keybind Schema

One set of rules that works the same everywhere: Windows host, Kali in VMware (Xfce), CachyOS (niri / KDE), tmux and Neovim.

## The core rule

**The modifier picks the layer. The letter picks the action.**

When you can't remember a bind, ask yourself two things: which layer am I talking to, and what am I doing? Together they give you the key.

## Layers (the modifiers)

|   |   |
|---|---|
|Modifier|Talks to|
|Super|Window manager (niri on CachyOS, Xfce in Kali)|
|Ctrl+A, then key (press Ctrl+A twice for start of line)|tmux (prefix)|
|Ctrl+W, then h/j/k/l|Move between Neovim splits (tmux uses its prefix, nothing held down)|
|Ctrl|Tabs and actions inside apps (browser, editor, file manager)|
|Ctrl+Shift|The same app actions, but inside a terminal|

## Verbs (the same letter in every layer)

|   |   |
|---|---|
|Key|Action|
|h / j / k / l (or arrows)|Focus left / down / up / right|
|Shift + h/j/k/l|Move the window or pane in that direction|
|Enter|New terminal (WM) / new pane (tmux)|
|Space|Launcher / app menu|
|Q|Close (Super+Q window, Ctrl+Shift+Q terminal tab, prefix q pane, prefix Shift+Q tmux window, Ctrl+W q Neovim window)|
|T|New tab (Ctrl+T, Ctrl+Shift+T in terminals); tmux keeps its own prefix c for a new window|
|F|Fullscreen (WM) / zoom pane (tmux)|
|Shift+F|Toggle floating (tmux: popup shell that keeps running, prefix Shift+F again hides it)|
|1–9|Go to workspace / tmux window / tab|
|Shift+1–9|Send window to workspace|
|Tab|Jump back to the last workspace|
|R|Resize mode, then h/j/k/l, Escape to leave|
|Shift+R|Reload config|
|Shift+Escape|Shut the whole thing down: Super+Shift+Escape logs out, prefix Shift+Escape kills the tmux session (asks first), Shift+Escape in Neovim quits everything (asks if unsaved)|
|Escape|Back out, never destroys anything: leaves the tmux prefix, copy mode and resize mode, and vim modes|

## Splitting

Splitting only applies to tmux and Neovim, not the window manager (new windows place themselves).

- tmux: prefix + V (vertical split), prefix + S (horizontal split); prefix + h/j/k/l to focus a pane, prefix + Shift + h/j/k/l to move it; prefix + O cycles the preset layouts (moved from prefix + Space)
- Neovim: Ctrl+W then V / S, rarely needed: use tmux panes instead. Ctrl+W q closes windows Neovim opens itself (help, diffs)
- tmux defaults this replaces: move the window list and session list to other keys

## Copy and paste

- Apps: Ctrl+C / Ctrl+V as normal
- Terminals: Ctrl+Shift+C / Ctrl+Shift+V
- tmux copy mode: prefix + [ (default), then v to select and y to copy, vim style; copy to the system clipboard

## Search

- / everywhere: Neovim, less, tmux copy mode, browser (with Vimium)

## Shell notes

- Ctrl+L keeps its normal job of clearing the screen
- GUI apps keep their own close keys; Q is for everything driven from the keyboard
- Shift+Escape only works if the terminal sends it as its own key (CSI u). The setup configures Windows Terminal and kitty to do that; elsewhere it falls back to plain Escape, which is harmless
- Ctrl+Shift+Escape is never used: Windows always opens Task Manager on it

## Sofle keyboard layers (set up in Vial)

- **Base layer:** brackets kept in their usual spot to the right of P (for tmux copy mode, Vim and code)
- **Super key = layer-mod (LM):** holds Super and turns on the nav layer at the same time. On that layer H/J/K/L send arrow keys, so Super+L goes out as Super+Right. This stops Win+L locking the Windows host when you're working in the VM. Every other key still sends Super as normal.
- **Nav layer:** h/j/k/l = arrows, so vim keys and arrow keys are the same physical keys
- **Function layer (its own thumb key):** F1–F12, volume, brightness, media controls. Kept off the Super layer so Super doesn't get added to them.

## Platform notes

### Windows (host)

- No tiling window manager; move windows with the mouse
- Win+L is lost to the layer-mod trick; lock through the GUI or Ctrl+Alt+Delete instead
- Screenshots happen here only: Flameshot, with Win+Shift+S remapped to Print Screen in PowerToys Keyboard Manager. Turn off "Use the Print screen key to open screen capture" in Windows keyboard settings.
- App shortcuts (Ctrl+W, Ctrl+T, Ctrl+Tab, Ctrl+1–9) already follow the schema

### Kali in VMware (Xfce)

- Mostly terminals: run a fullscreen terminal with tmux, which handles splitting, moving and windows on the prefix
- Xfce shortcuts to match the schema: Super+Enter terminal, Super+Space app menu, Super+Q close, Super+1–9 workspaces
- VMware passes Super through to the VM; the layer-mod trick handles the Win+L problem
- VM kept to one monitor
- i3 was tried and dropped: more complexity than a mostly-terminal setup needs

### CachyOS (niri)

- Already uses Mod+h/j/k/l for focus by default
- Move: Mod+Ctrl+h/j/k/l → Super+Shift+h/j/k/l
- Close: keep the default Mod+Q
- Terminal: Mod+T → Super+Enter
- Launcher: Mod+D → Super+Space
- Multi-monitor: use the "focus column or monitor" actions so Super+h/l carries on to the next screen at the edge
- Built-in shortcut inhibit toggle for passing keys through to a VM

### CachyOS (KDE)

- Rebind "switch to window left/right/up/down" to Meta+h/j/k/l and close to Meta+Q
- Moving is snapping rather than real tiling

### Xfce

- No directional focus, so h/j/k/l focus isn't used here; tmux covers it inside the terminal
