#!/bin/sh
set -e

AUTH_SERVER_HOSTNAME="$1"
AUTH_SERVER_PORT="$2"
KC_REALM="$3"

echo "Waiting for Keycloak..."
until wget -qO- "http://${AUTH_SERVER_HOSTNAME}:${AUTH_SERVER_PORT}/realms/master" > /dev/null 2>&1; do
  sleep 2
done
echo "Keycloak is ready."

cd /workspace
terraform init

if terraform import module.realms.keycloak_realm.realm "$KC_REALM" 2>/dev/null; then
  echo "Realm imported."
else
  echo "Realm will be created."
fi

terraform apply -parallelism=4 -auto-approve

# Extract secrets
MEDIACMS_SECRET=$(terraform output -raw mediacms_client_secret)
ANNOTATOR_SECRET=$(terraform output -raw annotator_client_secret)
mkdir -p /secrets
echo "$MEDIACMS_SECRET" > /secrets/mediacms_client_secret
echo "$ANNOTATOR_SECRET" > /secrets/annotator_client_secret
head -c 32 /dev/urandom | base64 | head -c 32 > /secrets/oauth2_cookie_secret

# Dev phase — only runs if /workspace/dev is mounted
if [ -d /workspace/dev ]; then
  echo "=== Dev config detected, applying... ==="
  cd /workspace/dev
  terraform init -backend=false
  export TF_VAR_realm_id="$KC_REALM"
  terraform apply -parallelism=4 -auto-approve
  echo "=== Dev config applied ==="
fi