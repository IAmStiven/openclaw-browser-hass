#!/usr/bin/with-contenv sh
set -eu

echo "[openclaw] Starting wrapper..."

# Persist Chrome profile data in add-on config dir
# HA add-on persistent path: /data (inside container)
PERSIST_DIR="/data/chrome"
CHROME_DIR="/home/sandbox-browser/.chrome"

mkdir -p "${PERSIST_DIR}"

# If the upstream image already has a directory here, replace it with a symlink
if [ -e "${CHROME_DIR}" ] && [ ! -L "${CHROME_DIR}" ]; then
  rm -rf "${CHROME_DIR}"
fi

if [ ! -e "${CHROME_DIR}" ]; then
  ln -s "${PERSIST_DIR}" "${CHROME_DIR}"
fi

# Ensure /dev/shm is big enough (Chrome really wants this).
# Needs SYS_ADMIN capability from config.json.
# If this fails for any reason, continue, but warn.
if mountpoint -q /dev/shm; then
  umount /dev/shm || true
fi

if mount -t tmpfs -o size=2g tmpfs /dev/shm 2>/dev/null; then
  echo "[openclaw] Mounted /dev/shm as tmpfs size=2g"
else
  echo "[openclaw] WARNING: Could not mount /dev/shm to 2g. Chrome may be unstable under load."
fi

# Read HA add-on options from /data/options.json
# Bash-free parsing using jq (usually present). If jq isn't present, fall back to defaults.
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

# Keep internal ports standard (HA UI can remap host ports if needed)
export CLAWDBOT_BROWSER_CDP_PORT="9222"
export CLAWDBOT_BROWSER_VNC_PORT="5900"
export CLAWDBOT_BROWSER_NOVNC_PORT="6080"

echo "[openclaw] Options: headless=${CLAWDBOT_BROWSER_HEADLESS}, enable_novnc=${CLAWDBOT_BROWSER_ENABLE_NOVNC}"
echo "[openclaw] Ports: cdp=${CLAWDBOT_BROWSER_CDP_PORT}, vnc=${CLAWDBOT_BROWSER_VNC_PORT}, novnc=${CLAWDBOT_BROWSER_NOVNC_PORT}"
echo "[openclaw] Chrome profile persisted at: ${PERSIST_DIR}"

# Hand off to the upstream image's default command
# (We don't override CMD in Dockerfile, so this should run the browser service)
exec /usr/bin/env "$@"
