#!/usr/bin/env python3
"""Set up Windows Terminal's keys from keybinds.md. Its own colours and look are left alone.

Usage: windows-terminal.py <settings.json> <WSL distro name> <backups to keep> [--check]

- Copy / paste on Ctrl+Shift+C / V; Ctrl+C and Ctrl+V go to the program (interrupt, nvim block select)
- Ctrl+Shift+Q closes the tab; Ctrl+Shift+W (Windows Terminal's close pane) is unbound
- Shift+Esc is sent as CSI u, so tmux and nvim can tell it from Esc
- Selecting text copies it (kitty: copy_on_select)
- The distro's profile is the default and uses the JetBrainsMono Nerd Font the wsl role installs
  (only the font face, for the icons eza shows; size and everything else stay as they are)

Prints "changed" or "ok" (--check: only prints, writes nothing). Everything else in settings.json is left alone.
"""
import copy
import glob
import json
import os
import re
import sys
import time

settings_path, distro, keep = sys.argv[1], sys.argv[2], int(sys.argv[3])
check = "--check" in sys.argv[4:]

FONT_FACE = "JetBrainsMono NF"   # the family name Windows registers (not "JetBrainsMono Nerd Font")
PREFIX = "User.kali-setup."
ACTIONS = {
    "ctrl+shift+c": {"action": "copy", "singleLine": False},
    "ctrl+shift+v": "paste",
    "ctrl+shift+q": "closeTab",
    "shift+escape": {"action": "sendInput", "input": "\u001b[27;2u"},
}
UNBIND = ["ctrl+c", "ctrl+v", "ctrl+shift+w"]   # also unbinds Windows Terminal's own defaults
with open(settings_path, encoding="utf-8-sig") as f:
    try:
        cfg = json.load(f)
    except json.JSONDecodeError as e:
        sys.exit(f"can't parse {settings_path} ({e}); fix it or edit by hand")
before = copy.deepcopy(cfg)

# Keys: drop anything already on our keys, then add ours
ours = {keys: PREFIX + re.sub(r"\W", "_", keys) for keys in ACTIONS}
taken = set(ACTIONS) | set(UNBIND)
cfg["actions"] = [a for a in cfg.get("actions", []) if not str(a.get("id", "")).startswith(PREFIX)]
cfg["keybindings"] = [k for k in cfg.get("keybindings", []) if k.get("keys", "").lower() not in taken]
for keys, command in ACTIONS.items():
    cfg["actions"].append({"command": command, "id": ours[keys]})
    cfg["keybindings"].append({"id": ours[keys], "keys": keys})
for keys in UNBIND:
    cfg["keybindings"].append({"id": None, "keys": keys})

cfg["copyOnSelect"] = True

profiles = [p for p in cfg.get("profiles", {}).get("list", [])
            if p.get("name") == distro and p.get("source") == "Microsoft.WSL" and not p.get("hidden")]
for p in profiles:
    p["font"] = {**p.get("font", {}), "face": FONT_FACE}
if profiles:
    cfg["defaultProfile"] = profiles[0]["guid"]

if cfg == before or check:
    print("ok" if cfg == before else "changed")
    sys.exit()

# Same backup naming and pruning as the dotfiles role (file.<timestamp>~, newest `keep` kept)
with open(settings_path, encoding="utf-8-sig") as f:
    original = f.read()
with open(f"{settings_path}.{time.strftime('%Y-%m-%d@%H%M%S')}~", "w", encoding="utf-8") as f:
    f.write(original)
for old in sorted(glob.glob(glob.escape(settings_path) + ".*~"), key=os.path.getmtime)[:-keep]:
    os.remove(old)

with open(settings_path, "w", encoding="utf-8") as f:
    json.dump(cfg, f, indent=4)
    f.write("\n")
print("changed")
