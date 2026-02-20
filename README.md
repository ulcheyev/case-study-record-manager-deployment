# case-study-record-manager-deployment
This repository provides an example deployment of the Record Manager ecosystem.
It demonstrates how the individual services of the ecosystem are configured, integrated, and 
deployed together in a reproducible environment.

This deployment is based on [Keycloak based Record Manager Deployment](https://github.com/ulcheyev/record-manager-ui/tree/main/deploy/keycloak-auth)

1. run envs init
2. assign roles, for advanced use terraform!
3. if changed origin for example for dev -> also change in keycloak, add origin in realm!
4. setup passwords and users in env
4. docker compose build
5. to use media cms or annotator it is need to assign role


#!/bin/sh

AUTH_SERVER_HOSTNAME="$1"
AUTH_SERVER_PORT="$2"
KC_REALM="$3"

SECRETS_DIR="/secrets"
MEDIACMS_SECRET_FILE="$SECRETS_DIR/mediacms_client_secret"
ANNOTATOR_SECRET_FILE="$SECRETS_DIR/annotator_client_secret"
COOKIE_SECRET_FILE="$SECRETS_DIR/oauth2_cookie_secret"

echo INFO: Waiting for keycloak authorizaion server running at $AUTH_SERVER_HOSTNAME:$AUTH_SERVER_PORT ...

until nc -z $AUTH_SERVER_HOSTNAME $AUTH_SERVER_PORT; do
sleep 1;
done

echo INFO: keycloak authorizaion server running at $AUTH_SERVER_HOSTNAME:$AUTH_SERVER_PORT
echo "Terraform will be applied..."

terraform init
terraform import keycloak_realm.realm $KC_REALM
terraform apply -auto-approve

echo "Terraform applied. Extracting secret..."
mkdir -p "$SECRETS_DIR"
MEDIACMS_SECRET=$(terraform output -raw mediacms_client_secret)
echo "$MEDIACMS_SECRET" > "$MEDIACMS_SECRET_FILE"

SECRET_ANNOTATOR=$(terraform output -raw annotator_client_secret)
echo "$SECRET_ANNOTATOR" > "$ANNOTATOR_SECRET_FILE"

echo "Ensuring oauth2 cookie secret..."

if [ ! -f "$COOKIE_SECRET_FILE" ]; then
head -c 32 /dev/urandom | base64 | tr -d '\n' > "$COOKIE_SECRET_FILE"
fi

echo "All secrets generated successfully."



