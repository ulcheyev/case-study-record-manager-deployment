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

# If host is localhost, replace with host-gateway IP
if [ "$HOST" = "localhost" ]; then
  HOST_IP=$(grep 'localhost$' /etc/hosts | awk '{print $1}' | tail -1)
  DISCOVERY_URL=$(echo "$DISCOVERY_URL" | sed "s|localhost:${PORT}|${HOST_IP}:${PORT}|")
fi

echo "Resolved discovery URL: $DISCOVERY_URL"
echo "Waiting for OIDC discovery endpoint to return HTTP 200..."

while true; do
  STATUS=$(wget -q --server-response --spider "$DISCOVERY_URL" 2>&1 \
    | awk '/HTTP\// {print $2}' | tail -1)

  if [ "$STATUS" = "200" ]; then
    echo "OIDC discovery endpoint ready."
    break
  fi

  sleep 2
done

exec /bin/oauth2-proxy