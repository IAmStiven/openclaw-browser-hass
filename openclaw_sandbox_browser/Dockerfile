FROM ghcr.io/iamevanyt/openclaw-sandbox-browser:latest

EXPOSE 9222 5900 6080

USER root

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bun","run","start"]
