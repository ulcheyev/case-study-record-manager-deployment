#!/bin/sh
set -e

SECRET_FILE="/secrets/annotator_client_secret"
COOKIE_SECRET_FILE="/secrets/oauth2_cookie_secret"

echo "Waiting for secrets..."
while [ ! -s "$SECRET_FILE" ] || [ ! -s "$COOKIE_SECRET_FILE" ]; do
  sleep 1
done
echo "Secrets injected."

export OAUTH2_PROXY_CLIENT_SECRET="$(cat $SECRET_FILE)"
export OAUTH2_PROXY_COOKIE_SECRET="$(cat $COOKIE_SECRET_FILE)"

KC_REALM="${KC_REALM:-record-manager}"
DISCOVERY_URL="http://auth-server:8080/realms/${KC_REALM}/.well-known/openid-configuration"

echo "Waiting for Keycloak realm at ${DISCOVERY_URL}..."
until wget -qO- "${DISCOVERY_URL}" > /dev/null 2>&1; do
  sleep 5
done
echo "Keycloak realm is ready."

exec /bin/oauth2-proxy