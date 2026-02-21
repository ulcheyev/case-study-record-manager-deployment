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

exec /bin/oauth2-proxy