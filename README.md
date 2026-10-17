# Kali setup

Ansible playbook that sets up a Kali machine with my tools and configs.

## Fresh machine

```sh
git clone https://github.com/f71p/kali-setup.git ~/Projects/setup
cd ~/Projects/setup && ./bootstrap.sh
```

To push changes back, run `gh auth login` and `gh auth setup-git` (the playbook installs `gh`).

## Usage

```sh
./bootstrap.sh                          # run everything (installs ansible first if needed)
./bootstrap.sh --tags dotfiles          # run only some modules, comma-separated
./bootstrap.sh --skip-tags desktop      # run everything except some modules
./bootstrap.sh --check --diff           # dry run: show what would change
```

`bootstrap.sh` asks for your sudo password and passes any extra arguments to `ansible-playbook`.
Once ansible is installed, `ansible-playbook site.yml -K [--tags ...]` does the same thing.

| Tag | What it does |
|---|---|
| `apt` | Extra apt repos, then packages from `packages/apt.txt` (sudo) |
| `pipx` | Python tools from `packages/pipx.txt` |
| `go` | Go tools from `packages/go.txt` |
| `cargo` | Rust tools from `packages/cargo.txt` (compiles — slow, needs RAM) |
| `releases` | Prebuilt binaries from `packages/github-releases.txt` |
| `git` | Clones repos from `packages/git-repos.txt` |
| `dotfiles` | Copies `configs/` into place |
| `wordlists` | Unzips rockyou (sudo) |
| `desktop` | Disables XFCE screen lock/blanking; sets keyboard layout (`keyboard_layout`, sudo) |

After editing a config in `configs/`, apply it with `./bootstrap.sh --tags dotfiles`.

## Scripts

Installed to `~/.local/bin` from `configs/home/.local/bin/`. Each one prints its usage with `-h`.

| Command | What it does |
|---|---|
| `extract <archive>...` | Unpacks any common archive into a folder named after it |
| `cmd \| clip`, `clip <file>` | Copies to the clipboard (reaches the Windows host); `clip` alone prints it |
| `rec [label]` | Records the terminal (output only) to `$LOGS/<date>/` until `exit`; tmux shows ● REC |
| `logcat <log>` | Shows a `rec` log as plain text; replay with `scriptreplay -T <file>.timing <file>.log` |
| `tmux-netinfo` | tmux status bar: tun0 IP when the VPN is up, else eth0 |

`$LOGS` (`~/logs`) is the central place for recordings and tool output, e.g. `nmap -oA $LOGS/scan`.

## Layout

| Path | Purpose |
|---|---|
| `packages/apt.txt` | APT packages |
| `packages/pipx.txt` | Python tools: `<name> [source]`, kept at latest. Use this over apt for Python tools |
| `packages/go.txt` | Go tools (`go install`, `@latest` default) |
| `packages/cargo.txt` | Rust tools (`cargo install`), kept at latest |
| `packages/github-releases.txt` | Prebuilt binaries from GitHub releases → `~/.local/bin`, checksum-verified, kept at latest |
| `packages/git-repos.txt` | Repos: `<url> [dest]`, default dest `~/tools/<name>` |
| `configs/home/` | Mirrors `$HOME` — e.g. `configs/home/.tmux.conf` → `~/.tmux.conf` |
| `configs/home/.zshrc.d/` | Personal zsh config. `.zshrc` itself is Kali's stock file plus one line that loads these |
| `configs/system/` | Mirrors `/` — e.g. `configs/system/etc/foo.conf` → `/etc/foo.conf` |
| `roles/wordlists`, `roles/desktop` | Unzip rockyou; disable XFCE screen lock/blanking |
| `roles/` | One role per module; tag name matches |
| `group_vars/all.yml` | Paths, settings, extra apt repositories (e.g. GitHub CLI) |

List files: one entry per line, `#` starts a comment, blank lines ignored.
Overwritten config files are backed up next to the original with a timestamp suffix.

## Adding a module

1. Add `packages/<name>.txt` and a matching `<name>_packages` var in `group_vars/all.yml`.
2. Create `roles/<name>/tasks/main.yml`.
3. Add the role with a tag in `site.yml`.
