# Dockerfile
FROM ghcr.io/iamevanyt/openclaw-sandbox-browser:latest

# Same target port as your compose service
EXPOSE 9222
EXPOSE 5900
EXPOSE 6080

# Same data directory as your compose volume mount
VOLUME ["/home/sandbox-browser/.chrome"]

# Explicitly match upstream default command
CMD ["bun", "run", "start"]
