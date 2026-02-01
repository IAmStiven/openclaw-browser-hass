#!/bin/sh
set -eu

SRC="/config/openclaw-browser"
DST="/home/openclaw-browser"

# Ensure source exists (persistent)
mkdir -p "$SRC"

# Ensure destination exists as a REAL directory (not symlink/file)
if [ -L "$DST" ] || [ -f "$DST" ]; then
  rm -rf "$DST"
fi
mkdir -p "$DST"

# If not already mounted, bind-mount SRC -> DST
# (mountpoint may not exist on all images; fall back to parsing /proc/mounts)
if ! grep -qs " $DST " /proc/mounts; then
  mount --bind "$SRC" "$DST"
fi

# Make it writable no matter what user bun/chrome runs as
chmod -R 0777 "$SRC" || true

exec "$@"
