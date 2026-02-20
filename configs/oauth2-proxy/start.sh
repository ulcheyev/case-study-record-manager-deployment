#!/bin/sh
set -e

SECRET_FILE="/secrets/annotator_client_secret"
COOKIE_SECRET_FILE="/secrets/oauth2_cookie_secret"

echo "Waiting for secrets..."

while [ ! -s "$SECRET_FILE" ] || [ ! -s "$COOKIE_SECRET_FILE" ]; do
  sleep 1
done

echo "Secrets injected."

exec /bin/oauth2-proxy