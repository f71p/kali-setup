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
# `cat` stays plain (no line numbers, no pager) so output copies cleanly; `command cat` for the real one.
# bat can't show images, so in kitty those are drawn by `kitten icat` instead: `cat pic.png`
if command -v batcat >/dev/null; then
    _bat_or_image() {    # $1: bat options, then the files
        local opts=$1 f; shift
        local -a imgs=()
        if [[ -t 1 && -n $KITTY_WINDOW_ID && -z ${(M)argv:#-*} ]]; then    # to the terminal, no options
            for f; do [[ $(file -bL --mime-type -- "$f" 2>/dev/null) == image/* ]] && imgs+=$f; done
        fi
        if (( ! $#imgs )); then batcat ${=opts} "$@"; return; fi
        for f; do
            if (( $imgs[(Ie)$f] )); then kitten icat --align left -- "$f"; else batcat ${=opts} -- "$f"; fi
        done
    }
    cat() { _bat_or_image '--style=plain --paging=never' "$@"; }
    bat() { _bat_or_image '' "$@"; }
    export MANPAGER="sh -c 'col -bx | batcat -l man -p'" MANROFFOPT=-c   # coloured man pages
fi

# File picker (ctrl+T / ctrl+F) preview: images, text (bat) and folders (~/.local/bin/fzf-preview)
export FZF_CTRL_T_OPTS="--preview 'fzf-preview {}'"
