# Time on the right of the prompt, updated when Enter is pressed: scrollback shows when each command ran.
# (Kali's two-line prompt leaves RPROMPT empty; the one-line style, ctrl+P, clears it.)
RPROMPT='%F{8}%D{%H:%M:%S}%f'

# Redraw the prompt at Enter so the time is the run time, not when the prompt appeared.
# Defined before the autosuggestion/highlighting plugins load, so they wrap this widget.
_accept_line_with_time() {
    [[ -n $BUFFER ]] && zle reset-prompt
    zle .accept-line
}
zle -N accept-line _accept_line_with_time
