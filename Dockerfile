FROM ghcr.io/iamevanyt/openclaw-sandbox-browser:latest

# Home Assistant add-ons commonly run scripts from root
COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
