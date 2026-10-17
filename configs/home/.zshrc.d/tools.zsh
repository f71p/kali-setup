# zoxide: `z <partial dir>` jumps to frequently used directories, `zi` to pick interactively
if command -v zoxide >/dev/null; then
    eval "$(zoxide init zsh)"
fi

# Neovim as the default editor
if command -v nvim >/dev/null; then
    export EDITOR=nvim VISUAL=nvim
    alias vim=nvim
fi
