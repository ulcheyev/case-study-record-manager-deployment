# Case Study: Record Manager Deployment
This repository provides a reproducible deployment of the Record Manager ecosystem, integrating UI, backend services, authentication, MediaCMS, and supporting infrastructure.

The deployment is based on:
- 🔗 [Keycloak based Record Manager Deployment](https://github.com/kbss-cvut/record-manager-ui/tree/main/deploy/keycloak-auth)
- 🔗 [Keycloak based Record Manager Setup Guide](https://github.com/kbss-cvut/record-manager-ui/blob/main/doc/setup.md)

---
## 📑 Table of Contents

1. [Deployment Setup](#1-deployment-setup)
  - [1.1 Authentication Configuration](#11-authentication-configuration)
  - [1.2 Scaling Configuration](#12-scaling-configuration)
  - [1.3 MediaCMS Configuration](#13-mediacms-configuration)
  - [1.4 Environment Configuration](#14-environment-configuration)
  - [1.5 Build and Start Services](#15-build-and-start-services)
2. [Role and Group Management](#2-role-and-group-management)

---

## 1. Deployment Setup

### 1.1 Authentication Configuration

Before starting the deployment, configure authentication.

Refer to:
- 🔗 [Authentication Docs](./docs/AUTH.md)

Authentication is based on:
- **Keycloak realm**: `record-manager`
- **OIDC clients** for:
  - `record-manager`
  - `mediacms`
  - `annotator`

---

### 1.2 Scaling Configuration
Refer to:
- 🔗 [Scaling Docs](./docs/SCALE.md)

### 1.3 MediaCMS Configuration

The default configuration provides fundamental access.

- **Configuration directory**: `configs/mediacms`

For advanced configuration, refer to:
- 🔗 [MediaCMS Admin Docs](https://github.com/mediacms-io/mediacms/blob/main/docs/admins_docs.md#5-configuration)

**Important**:
- Users must have appropriate roles assigned in Keycloak.
- Without correct role assignment, access will be denied.

---

### 1.4 Environment Configuration

Configure environment variables before starting the deployment.

A detailed description is provided in:
- `.env.example`

Create your environment file:
```bash
cp .env.example .env
```

Then configure the following (⚠️ Important):
- Keycloak admin credentials
- Database passwords
- MediaCMS admin credentials

---

### 1.5 Build and Start Services

The deployment supports two modes:

- **Local development (localhost)**
- **Domain-based deployment (PUBLIC_ORIGIN defined)**

---

#### 🔹 Local Development Mode

If the stack is running locally (e.g., `http://localhost`), you must apply the local override file.

This enables:

- Insecure OIDC issuer skip (for localhost)
- Non-secure cookies (HTTP)

Run:

```bash
docker compose \
  -f docker-compose.yml \
  -f docker-compose.local.yml \
  --env-file .env \
  up --build -d
```

#### 🔹 Domain-Based Deployment

If running under a domain and `PUBLIC_ORIGIN` is properly defined in .env,
do not apply the dev override file.

Run:
```bash
docker compose --env-file .env up --build -d
```

#### Synchronizing Keycloak Changes
The keycloak-config (Terraform) container is the source of truth for Keycloak configuration.
Manual changes made in the Keycloak Admin UI may be overwritten by Terraform configuration during the next application restart.

##### Client Secrets Update
Client secrets `keycloak-secrets` are shared at runtime. The following services consume secrets:
- OAuth2 Proxy (Annotator authentication)
- MediaCMS

If a client secret is modified manually in the Keycloak UI it is needed to regenerate and synchronize the secrets. Re-run the `keycloak-config` container and restart the dependent services:
```bash
docker compose down keycloak-config oauth2-proxy mediacms nginx
docker volume rm <project>_keycloak-secrets
docker compose --env-file .env up -d keycloak-config oauth2-proxy mediacms nginx
```
In order to resolve newly assigned IP addresses after restart, gateway need to be restarted too.

---

## 2. Role and Group Management

- Roles are defined at the realm level and grouped via Terraform.
- Users must 
  - be assigned to a group or
  - roles must be assigned to users to gain access to services
- Each group contains a predefined set of realm roles.





