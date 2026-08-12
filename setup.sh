#!/bin/bash
# Stages this repo into an Obsidian vault so Claude Code can run the
# interactive /setup skill from inside it.
#
# Usage (from wherever you cloned this repo):
#   ./setup.sh /path/to/your/vault
#   ./setup.sh .            # if you're already sitting in the vault root
#
# What it does:
#   1. Copies this repo (minus .git) into <vault>/.claude/.gta-source/, so
#      the setup skill has everything it needs even after this clone is
#      deleted.
#   2. Copies skills/setup/SKILL.md into <vault>/.claude/skills/setup/, so
#      Claude Code picks it up as soon as you cd into the vault.
#
# It does NOT touch anything else in your vault, and does NOT run Claude
# Code itself - read the printed next steps and take it from there.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT="${1:-.}"

if [ ! -d "$VAULT" ]; then
  echo "Vault path not found: $VAULT" >&2
  echo "Usage: ./setup.sh /path/to/your/vault" >&2
  exit 1
fi
VAULT="$(cd "$VAULT" && pwd)"

STAGING="$VAULT/.claude/.gta-source"
SKILL_DIR="$VAULT/.claude/skills/setup"

mkdir -p "$STAGING" "$SKILL_DIR"
cp -R "$SCRIPT_DIR/." "$STAGING/"
rm -rf "$STAGING/.git"
cp "$SCRIPT_DIR/skills/setup/SKILL.md" "$SKILL_DIR/SKILL.md"

cat <<EOF

Staged getting-things-adhdone into:
  $STAGING

Next steps:
  cd "$VAULT"
  claude
  /setup

The /setup skill will ask a few questions and scaffold the rest (CLAUDE.md,
templates, folder structure, and the right skills for how you track tasks).
You can delete .claude/.gta-source afterwards - it's just staging.
EOF
