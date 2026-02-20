#!/bin/sh

AUTH_SERVER_HOSTNAME="$1"
AUTH_SERVER_PORT="$2"
KC_REALM="$3"

until nc -z $AUTH_SERVER_HOSTNAME $AUTH_SERVER_PORT; do
  echo INFO: Waiting for keycloak authorizaion server running at $AUTH_SERVER_HOSTNAME:$AUTH_SERVER_PORT ...
  sleep 1;
done


terraform init
terraform import keycloak_realm.realm $KC_REALM
terraform apply -auto-approve

echo "Terraform applied. Extracting secret..."

MEDIACMS_SECRET=$(terraform output -raw mediacms_client_secret)
ANNOTATOR_SECRET=$(terraform output -raw annotator_client_secret)
mkdir -p /secrets
echo "$MEDIACMS_SECRET" > /secrets/mediacms_client_secret
echo "$ANNOTATOR_SECRET" > /secrets/annotator_client_secret
head -c 32 /dev/urandom | base64 | tr -d '\n' > /secrets/oauth2_cookie_secret

echo "Done."