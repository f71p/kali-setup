# fetch: system info with the animated neon Kali dragon (needs kitty, fastfetch, `fetch-logo` output).
# Shown automatically when a new kitty window opens (not in every tmux pane); run `fetch` any time.
fetch() {
    local img=${FETCH_LOGO:-$HOME/.local/share/fetch/logo.gif}
    command -v fastfetch >/dev/null || { echo "fetch: needs fastfetch (./bootstrap.sh --tags apt)" >&2; return 1; }
    if [[ -z $KITTY_WINDOW_ID || ! -f $img ]] || ! command -v kitten >/dev/null; then
        fastfetch; return                                  # no kitty or no logo: plain fastfetch
    fi
    # Cell size in pixels from the tty (kitten's own query hangs inside tmux)
    local cols rows wpx hpx iw ih
    read -r cols rows wpx hpx < <(python3 -c 'import fcntl,termios,struct
r,c,x,y = struct.unpack("HHHH", fcntl.ioctl(open("/dev/tty"), termios.TIOCGWINSZ, bytes(8))); print(c, r, x, y)')
    read -r iw ih < <(identify -format '%w %h\n' "${img}[0]")
    (( wpx && hpx )) || { fastfetch; return; }
    local img_cols=$(( (iw * cols + wpx - 1) / wpx )) img_rows=$(( (ih * rows + hpx - 1) / hpx ))
    # Image first (at the cursor, so kitty animates it even in tmux), then info beside it
    kitten icat --align left "$img"
    local -a info=("${(@f)$(fastfetch --pipe false </dev/null)}")
    printf '\e[%dA\e[?7l' $img_rows                        # back to the image top; no line wrapping
    local line; for line in "${info[@]}"; do printf '\e[%dC%s\n' $(( img_cols + 3 )) "$line"; done
    printf '\e[?7h'
    (( ${#info} < img_rows )) && printf '\e[%dB' $(( img_rows - ${#info} ))
    return 0
}

# Auto-run in a fresh kitty window's first shell (not inside tmux, not in nested shells)
[[ -o interactive && -n $KITTY_WINDOW_ID && -z $TMUX && $SHLVL -le 1 ]] && command -v fastfetch >/dev/null && fetch
