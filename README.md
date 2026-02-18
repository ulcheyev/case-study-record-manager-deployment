# case-study-record-manager-deployment
This repository provides an example deployment of the Record Manager ecosystem.
It demonstrates how the individual services of the ecosystem are configured, integrated, and 
deployed together in a reproducible environment.

This deployment is based on [Keycloak based Record Manager Deployment](https://github.com/ulcheyev/record-manager-ui/tree/main/deploy/keycloak-auth)

1. run envs init
2. assign roles
3. if changed origin for example for dev -> also change in keycloak, add origin in realm!
4. setup passwords and users in env
4. docker compose build
5. to use media cms or annotator it is need to assign role  