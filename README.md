# Case Study: Record Manager Deployment
This repository provides a reproducible deployment of the Record Manager ecosystem, integrating UI, backend services, authentication, MediaCMS, and supporting infrastructure.

The deployment is based on:
- 🔗 [Keycloak based Record Manager Deployment](https://github.com/kbss-cvut/record-manager-ui/tree/main/deploy/keycloak-auth)
- 🔗 [Keycloak based Record Manager Setup Guide](https://github.com/kbss-cvut/record-manager-ui/blob/main/doc/setup.md)

---
## 📑 Table of Contents

1. [Deployment Setup](#2-deployment-setup)
  - [1.1 Authentication Configuration](#21-authentication-configuration)
  - [1.2 MediaCMS Configuration](#22-mediacms-configuration)
  - [1.3 Environment Configuration](#23-environment-configuration)
  - [1.4 Build and Start Services](#24-build-and-start-services)
2. [Role and Group Management](#3-role-and-group-management)
---

## 1. Deployment Setup

### 1.1 Authentication Configuration

Before starting the deployment, configure authentication.

Refer to:
- 🔗 [Authentication Docs](/AUTH.md)

Authentication is based on:
- **Keycloak realm**: `record-manager`
- **OIDC clients** for:
  - `record-manager`
  - `mediacms`
  - `annotator`

---

### 1.2 MediaCMS Configuration

The default configuration provides fundamental access.

- **Configuration directory**: `configs/mediacms`

For advanced configuration, refer to:
- 🔗 [MediaCMS Admin Docs](https://github.com/mediacms-io/mediacms/blob/main/docs/admins_docs.md#5-configuration)

**Important**:
- Users must have appropriate roles assigned in Keycloak.

---

### 1.3 Environment Configuration

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

### 1.4 Build and Start Services

The deployment supports two modes:

- **Local development (localhost)**
- **Domain-based deployment (PUBLIC_ORIGIN defined)**

---

#### 🔹 Local Development Mode

If the stack is running locally (e.g., `http://localhost`), you must apply the development override file.

This enables:

- Insecure OIDC issuer skip (for localhost)
- Non-secure cookies (HTTP)

Run:

```bash
docker compose \
  -f docker-compose.yml \
  -f docker-compose.dev.yml \
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

#### Rebuilding After Keycloak Changes

If the configuration was changed via the Keycloak configuration container at runtime, the whole stack must be rebuilt.

1. Stop and remove volumes:
   ```bash
   docker compose down -v
   ```

2. Rebuild and restart:
   ```bash
   docker compose --env-file .env up --build -d
   ```

- Updated client IDs are injected
- Updated secrets are propagated
- Updated issuer URLs are validated
- OAuth2 proxy configuration remains consistent

---

## 2. Role and Group Management

- Roles are defined at the realm level and grouped via Terraform.
- Users must 
  - be assigned to a group or
  - roles must be assigned to users to gain access to services.
- Each group contains a predefined set of realm roles.





