FROM ghcr.io/iamevanyt/openclaw-sandbox-browser:latest
USER root
RUN mkdir -p /config && ln -sf /home/openclaw-browser /config/openclaw-browser
USER 0
EXPOSE 9222 5900 6080
CMD ["bun","run","start"]
