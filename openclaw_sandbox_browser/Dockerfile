FROM ghcr.io/iamevanyt/openclaw-sandbox-browser:latest

EXPOSE 9222 5900 6080

USER root

# Make persistent home under /config, and point expected path to it.
# Use permissive perms so it works regardless of what UID the base image runs as.
RUN mkdir -p /config/openclaw-browser \
 && mkdir -p /home \
 && rm -rf /home/openclaw-browser \
 && ln -s /config/openclaw-browser /home/openclaw-browser \
 && chmod -R 0777 /config/openclaw-browser

# Keep the same command the upstream image uses
CMD ["bun", "run", "start"]
