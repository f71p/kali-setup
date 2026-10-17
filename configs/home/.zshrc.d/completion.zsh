# Commands with no completion of their own: complete -flags by parsing `cmd --help`.
# Only for commands found in $PATH (never ./scripts, which may not handle --help safely).
_help_fallback() {
    if [[ $PREFIX == -* && $words[1] != */* && -n $commands[$words[1]] ]]; then
        _gnu_generic && return
    fi
    _default
}
compdef _help_fallback -default-

# fzf-tab: fuzzy-searchable completion menu (must load after compinit, before autosuggestions)
if [ -f ~/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh ] && command -v fzf >/dev/null; then
    zstyle ':completion:*' menu no
    zstyle ':completion:*:descriptions' format '[%d]'
    zstyle ':fzf-tab:*' switch-group '<' '>'
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath'
    . ~/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
fi

# fzf key bindings: ctrl+R history, ctrl+T files, alt+C cd (loaded after fzf-tab so tab falls through to it)
if command -v fzf >/dev/null; then
    source <(fzf --zsh)
fi
