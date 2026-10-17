# Inside tmux, mark where each prompt and each command's output starts (OSC 133), so tmux can
# find the last command's output: prefix y (or ctrl+shift+Y in kitty) copies it.
# Outside tmux kitty's own shell integration does this.
# Each command line is also saved (per tmux pane / kitty window) so the copy can start with "$ command".
if [[ -n $TMUX ]]; then
    autoload -Uz add-zsh-hook
    # The prompt mark goes inside PROMPT: zsh clears the screen below the cursor as it draws the
    # prompt, which would wipe a mark printed beforehand. Re-added each time (Ctrl+P rebuilds PROMPT).
    _mark_prompt() { [[ $PROMPT == '%{'$'\e]133;A'* ]] || PROMPT='%{'$'\e]133;A\e\\''%}'$PROMPT; }
    _mark_output() { print -n '\e]133;C\e\\'; }
    add-zsh-hook precmd _mark_prompt
    add-zsh-hook preexec _mark_output
    _save_cmd() { print -r -- "$1" >| "${XDG_RUNTIME_DIR:-/tmp}/last-cmd-tmux$TMUX_PANE"; }
    add-zsh-hook preexec _save_cmd
    # Tell kitty this window is in tmux (user var, passed through tmux), so Ctrl+Shift+Y sends prefix y
    _kitty_in_tmux() { print -n '\ePtmux;\e\e]1337;SetUserVar=in_tmux=MQ==\a\e\\'; }
    add-zsh-hook precmd _kitty_in_tmux
elif [[ -n $KITTY_WINDOW_ID ]]; then
    # Back in a plain kitty shell (tmux exited or detached): clear the flag
    _kitty_not_tmux() { print -n '\e]1337;SetUserVar=in_tmux\a'; }
    autoload -Uz add-zsh-hook
    add-zsh-hook precmd _kitty_not_tmux
    _save_cmd() { print -r -- "$1" >| "${XDG_RUNTIME_DIR:-/tmp}/last-cmd-kitty$KITTY_WINDOW_ID"; }
    add-zsh-hook preexec _save_cmd
fi
