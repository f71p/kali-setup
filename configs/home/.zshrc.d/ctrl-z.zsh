# Ctrl+Z on an empty prompt brings back the program you suspended with Ctrl+Z (runs fg),
# so Ctrl+Z toggles between e.g. nvim and the shell.
_ctrl_z_fg() {
    [[ -z $BUFFER ]] && (( ${#jobstates} )) || return 0
    BUFFER=fg
    zle accept-line
}
zle -N _ctrl_z_fg
bindkey '^Z' _ctrl_z_fg
