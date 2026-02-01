#!/bin/sh
set -eu

HOME_DIR="/home/openclaw-browser"

# If it's a symlink or file (your EEXIST case), nuke it and recreate as a dir
if [ -L "$HOME_DIR" ] || [ -f "$HOME_DIR" ]; then
  rm -rf "$HOME_DIR"
fi
mkdir -p "$HOME_DIR"

# Make it writable even if the add-on config dir is root-owned
chmod -R 0777 "$HOME_DIR" || true

# Prefer to drop to the expected non-root user if it exists
if id openclaw-browser >/dev/null 2>&1; then
  exec su -s /bin/sh openclaw-browser -c "$*"
elif id sandbox-browser >/dev/null 2>&1; then
  exec su -s /bin/sh sandbox-browser -c "$*"
else
  # fallback: run as root
  exec "$@"
fi
