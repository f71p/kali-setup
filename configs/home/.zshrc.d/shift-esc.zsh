# Shift+Esc (sent as CSI u by kitty / Windows Terminal) shuts things down in tmux and nvim.
# At a bare prompt it does nothing, instead of typing "[27;2u".
_shift_esc_noop() { }
zle -N _shift_esc_noop
bindkey '\e[27;2u' _shift_esc_noop
bindkey '\e[27;2;27~' _shift_esc_noop
