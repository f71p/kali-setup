# Esc Esc puts sudo in front of the command being typed (or the last one, if the line is empty).
# Pressed again, it takes sudo off.
_sudo_toggle() {
    [[ -z $BUFFER ]] && { BUFFER=$(fc -ln -1); CURSOR=$#BUFFER; }
    if [[ $BUFFER == sudo\ * ]]; then
        BUFFER=${BUFFER#sudo }
        (( CURSOR -= 5 < CURSOR ? 5 : CURSOR ))
    else
        BUFFER="sudo $BUFFER"
        (( CURSOR += 5 ))
    fi
}
zle -N _sudo_toggle
bindkey '\e\e' _sudo_toggle
