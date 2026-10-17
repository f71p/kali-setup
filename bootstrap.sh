#!/usr/bin/env bash
# Install Ansible + required collections, then run the playbook.
# Extra args are passed to ansible-playbook, e.g. ./bootstrap.sh --tags apt
set -euo pipefail
cd "$(dirname "$0")"

if ! command -v ansible-playbook >/dev/null; then
  sudo apt-get update
  sudo apt-get install -y ansible
fi

ansible-galaxy collection install -r requirements.yml
ansible-playbook site.yml --ask-become-pass "$@"
