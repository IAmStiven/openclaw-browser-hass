#!/bin/sh
set -eu

echo "[openclaw] Starting wrapper..."

# Persist Chrome profile data in add-on config dir
PERSIST_DIR="/data/chrome"
mkdir -p "${PERSIST_DIR}"

# Prefer upstream documented path, but be resilient
if [ -d "/home/sandbox-browser" ] || [ ! -e "/home/sandbox-browser" ]; then
  USER_HOME="/home/sandbox-browser"
elif [ -d "/home/sandbox" ]; then
  USER_HOME="/home/sandbox"
else
  USER_HOME="/home/sandbox-browser"
fi

mkdir -p "${USER_HOME}"
CHROME_DIR="${USER_HOME}/.chrome"

echo "[openclaw] Using USER_HOME=${USER_HOME}"
ls -la /home || true
ls -la "${USER_HOME}" || true

# Replace existing .chrome with symlink to persistent storage
if [ -e "${CHROME_DIR}" ] && [ ! -L "${CHROME_DIR}" ]; then
  rm -rf "${CHROME_DIR}"
fi

# Ensure parent exists then link
mkdir -p "$(dirname "${CHROME_DIR}")"
ln -snf "${PERSIST_DIR}" "${CHROME_DIR}"

# Ensure /dev/shm is big enough
if mountpoint -q /dev/shm; then
  umount /dev/shm || true
fi
if mount -t tmpfs -o size=2g tmpfs /dev/shm 2>/dev/null; then
  echo "[openclaw] Mounted /dev/shm as tmpfs size=2g"
else
  echo "[openclaw] WARNING: Could not mount /dev/shm to 2g. Chrome may be unstable under load."
fi

# Read HA add-on options
HEADLESS="0"
ENABLE_NOVNC="1"
if command -v jq >/dev/null 2>&1 && [ -f /data/options.json ]; then
  HEADLESS_VAL="$(jq -r '.headless // false' /data/options.json)"
  NOVNC_VAL="$(jq -r '.enable_novnc // true' /data/options.json)"
  [ "${HEADLESS_VAL}" = "true" ] && HEADLESS="1" || HEADLESS="0"
  [ "${NOVNC_VAL}" = "true" ] && ENABLE_NOVNC="1" || ENABLE_NOVNC="0"
fi

export CLAWDBOT_BROWSER_HEADLESS="${HEADLESS}"
export CLAWDBOT_BROWSER_ENABLE_NOVNC="${ENABLE_NOVNC}"
export CLAWDBOT_BROWSER_CDP_PORT="9222"
export CLAWDBOT_BROWSER_VNC_PORT="5900"
export CLAWDBOT_BROWSER_NOVNC_PORT="6080"

echo "[openclaw] Options: headless=${CLAWDBOT_BROWSER_HEADLESS}, enable_novnc=${CLAWDBOT_BROWSER_ENABLE_NOVNC}"
