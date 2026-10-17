# zoxide: `z <partial dir>` jumps to frequently used directories, `zi` to pick interactively
if command -v zoxide >/dev/null; then
    eval "$(zoxide init zsh)"
fi

# Neovim as the default editor
if command -v nvim >/dev/null; then
    export EDITOR=nvim VISUAL=nvim
    alias vim=nvim
fi

# bat: cat with syntax highlighting. Debian names it batcat.
# `cat` stays plain (no line numbers, no pager) so output copies cleanly; `\cat` for the real one.
if command -v batcat >/dev/null; then
    alias bat=batcat
    alias cat='batcat --style=plain --paging=never'
    export MANPAGER="sh -c 'col -bx | batcat -l man -p'" MANROFFOPT=-c   # coloured man pages
    export FZF_CTRL_T_OPTS="--preview 'batcat --color=always --style=numbers --line-range=:300 {} 2>/dev/null || ls -1 --color=always {}'"
fi
