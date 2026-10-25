# WSL only (does nothing on the VM).

# Keep Windows interop working in long-lived tmux sessions.
# tmux keeps WSL_INTEROP from the terminal that started it; once that terminal closes the socket
# is gone and every .exe (win32yank for clip and nvim paste, explorer.exe...) fails until fixed.
[[ -n $WSL_DISTRO_NAME ]] || return 0

_wsl_interop_fix() {
    [[ -S $WSL_INTEROP ]] && return
    local s
    for s in /run/WSL/*_interop(N=om); do export WSL_INTEROP=$s; return; done
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _wsl_interop_fix

# Links open in the Windows default browser: xdg-open (xdg-utils) has a WSL mode that hands URLs to
# Windows and files to their Windows app. $BROWSER makes gh, python webbrowser, sensible-browser... use it.
export BROWSER=xdg-open
