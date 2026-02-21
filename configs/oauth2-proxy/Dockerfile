FROM quay.io/oauth2-proxy/oauth2-proxy:v7.6.0-alpine

USER root
COPY start.sh /start.sh
RUN chmod 755 /start.sh
USER 65532

ENTRYPOINT ["/start.sh"]