# OpenClaw Sandbox Browser (HA Add-on)

Exposes:
- 9222/tcp: CDP
- 5900/tcp: VNC (non-headless)
- 6080/tcp: NoVNC (non-headless + enabled)

Options (Add-on UI):
- headless: true/false
- enable_novnc: true/false

Persistence:
- Chrome profile is stored in the add-on persistent directory under /data/chrome

Notes:
- We mount /dev/shm to 2GB (requires SYS_ADMIN) because Chrome often crashes with small /dev/shm.
