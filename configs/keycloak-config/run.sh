#!/bin/sh
set -e

AUTH_SERVER_HOSTNAME="$1"
AUTH_SERVER_PORT="$2"
KC_REALM="$3"

echo "Waiting for Keycloak admin API to be ready..."
until wget -qO- "http://${AUTH_SERVER_HOSTNAME}:${AUTH_SERVER_PORT}/realms/master" > /dev/null 2>&1; do
  sleep 2
done
echo "Keycloak is ready."

terraform init

echo "Trying to import realm if it exists..."

if terraform import module.realms.keycloak_realm.realm "$KC_REALM"; then
  echo "Realm imported."
else
  echo "Realm does not exist yet. It will be created."
fi

echo "Applying Terraform..."
terraform apply -parallelism=4 -auto-approve

echo "Terraform applied. Extracting secret..."

MEDIACMS_SECRET=$(terraform output -raw mediacms_client_secret)
ANNOTATOR_SECRET=$(terraform output -raw annotator_client_secret)
mkdir -p /secrets
echo "$MEDIACMS_SECRET" > /secrets/mediacms_client_secret
echo "$ANNOTATOR_SECRET" > /secrets/annotator_client_secret
head -c 32 /dev/urandom | base64 | head -c 32 > /secrets/oauth2_cookie_secret

echo "Done."