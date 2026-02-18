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

SECRET=$(terraform output -raw mediacms_client_secret)
mkdir -p /secrets
echo "$SECRET" > /secrets/mediacms_client_secret

echo "Done."