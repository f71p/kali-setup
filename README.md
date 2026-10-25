# Kali setup

Ansible playbook for my Kali machines: the VMware VM and Kali on WSL.

Day-to-day keys and commands: [CHEATSHEET.md](CHEATSHEET.md) (or run `keys`).
The key scheme behind them: [keybinds.md](keybinds.md).

## What it sets up

- zsh: autosuggestions, fuzzy Tab completion, fzf history/file search, zoxide
- tmux and Neovim with the same vim-style keys, clipboard shared with Windows
- kitty on the VM, Windows Terminal on WSL
- Tools from apt, pipx, go, cargo, GitHub releases and git
- Small scripts: `clip`, `rec`, `extract`, `timesync`, `keys`, ... (see the cheat sheet)
- VM only: XFCE shortcuts, no screen lock, VMware shared folders and copy/paste fix
- WSL only: zsh as login shell, paste from Windows, links open in the Windows browser,
  Nerd Font and keys for Windows Terminal

## Install

```sh
git clone https://github.com/f71p/kali-setup.git ~/Projects/setup
cd ~/Projects/setup && ./bootstrap.sh
```

On WSL, close every Windows Terminal window once afterwards, and open Kali from the Terminal app.

## Usage

```sh
./bootstrap.sh                       # everything (asks for sudo)
./bootstrap.sh --tags dotfiles       # only some parts: apt, pipx, go, cargo, releases, git,
                                     #   dotfiles, wordlists, desktop, vmware, wsl
./bootstrap.sh --skip-tags upgrade   # skip the apt full-upgrade
./bootstrap.sh --check --diff        # dry run
```

`desktop` and `vmware` only run on the VM, `wsl` only on WSL.

## Adding things

- Packages: one per line in `packages/*.txt` (`apt`, `pipx`, `go`, `cargo`, `github-releases`, `git-repos`)
- Configs: `configs/home/` mirrors `~`, `configs/system/` mirrors `/`. Edit here, then `--tags dotfiles`
  (files in `~` get overwritten, with a timestamped backup)
- zsh: a new file in `configs/home/.zshrc.d/`

## If copy/paste to Windows breaks on the VM

1. `pgrep -a autocutsel` should list two. If not: `autocutsel -fork; autocutsel -selection PRIMARY -fork`
2. `restart-vm-tools`
3. Reopen kitty/tmux, or suspend and resume the VM
