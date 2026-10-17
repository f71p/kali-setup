# y: open yazi; when you quit, the shell changes to the directory you were in.
if command -v yazi >/dev/null; then
    y() {
        local tmp cwd
        tmp=$(mktemp -t yazi-cwd.XXXXXX)
        yazi "$@" --cwd-file="$tmp"
        IFS= read -r -d '' cwd < "$tmp"
        [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
        rm -f -- "$tmp"
    }
fi
