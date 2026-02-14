#!/usr/bin/env bash
# O/sync.sh — Bidirectional sync between local CONTENT and GitHub repo O
# Usage: bash sync.sh [push|pull|status]
# No args = full sync (pull then push)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

# Purge any desktop.ini that snuck in
find . -iname 'desktop.ini' -exec git rm --cached --ignore-unmatch {} + 2>/dev/null || true
find . -iname 'desktop.ini' -not -path './.git/*' -delete 2>/dev/null || true

action="${1:-sync}"

case "$action" in
  status)
    git fetch origin main --quiet 2>/dev/null || true
    echo "=== LOCAL STATUS ==="
    git status --short
    echo ""
    echo "=== AHEAD/BEHIND ==="
    git rev-list --left-right --count main...origin/main 2>/dev/null \
      | awk '{print "Local ahead: "$1"  Remote ahead: "$2}' || echo "Can't compare (offline?)"
    ;;
  pull)
    git fetch origin main --quiet
    git merge origin/main --no-edit --quiet || { echo "MERGE CONFLICT — resolve manually"; exit 1; }
    echo "Pulled latest from origin/main"
    ;;
  push)
    git add -A
    # Re-remove desktop.ini from index after add -A
    git rm --cached --ignore-unmatch '**/desktop.ini' 'desktop.ini' 2>/dev/null || true
    if git diff --cached --quiet; then
      echo "Nothing to push"
    else
      git commit -m "sync: $(date +%Y-%m-%d_%H%M)"
      git push origin main --quiet
      echo "Pushed to origin/main"
    fi
    ;;
  sync)
    # Pull first, then push
    git fetch origin main --quiet 2>/dev/null || true
    git merge origin/main --no-edit --quiet 2>/dev/null || true
    git add -A
    git rm --cached --ignore-unmatch '**/desktop.ini' 'desktop.ini' 2>/dev/null || true
    if git diff --cached --quiet; then
      echo "Already in sync"
    else
      git commit -m "sync: $(date +%Y-%m-%d_%H%M)"
      git push origin main --quiet
      echo "Synced"
    fi
    ;;
  *)
    echo "Usage: bash sync.sh [push|pull|status|sync]"
    exit 1
    ;;
esac
