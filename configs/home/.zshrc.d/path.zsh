# Tool install locations (cargo, go) ahead of system binaries
typeset -U path
path=(~/.cargo/bin ~/go/bin $path)
