FROM ghcr.io/iamevanyt/openclaw-sandbox-browser:latest

EXPOSE 9222
EXPOSE 5900
EXPOSE 6080

# Create persistent target + make the app's home point there
# (symlink /home/sandbox-browser -> /config/sandbox-browser)
USER root
RUN mkdir -p /config/sandbox-browser \
 && mkdir -p /home \
 && rm -rf /home/sandbox-browser \
 && ln -s /config/sandbox-browser /home/sandbox-browser \
 && chown -R 1000:1000 /config/sandbox-browser

# If the container already runs as sandbox-browser user, you can drop back.
# (If you're not sure, you can omit USER and keep whatever base image uses.)

CMD ["bun", "run", "start"]
