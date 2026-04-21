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

echo "Waiting for keycloak authorization server running ..."
DISCOVERY_PATH="/.well-known/openid-configuration"

ISSUER_URL="${OAUTH2_PROXY_OIDC_ISSUER_URL}"
DISCOVERY_URL="${ISSUER_URL}${DISCOVERY_PATH}"

echo "Original issuer URL: $ISSUER_URL"

# Extract host part
HOST=$(echo "$ISSUER_URL" | awk -F[/:] '{print $4}')
PORT=$(echo "$ISSUER_URL" | awk -F[/:] '{print $5}')

echo "Waiting for Keycloak at ${HOST}:${PORT}..."
until wget -qO- "${DISCOVERY_URL}" > /dev/null 2>&1; do
  sleep 2
done
echo "Keycloak is ready."

exec /bin/oauth2-proxy