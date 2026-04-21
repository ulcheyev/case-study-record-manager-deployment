# Authentication Configuration

Authentication is based on **OIDC (OpenID Connect)**, centrally managed by
**Keycloak**. Keycloak's realm, clients, roles, and groups are provisioned
by Terraform at deployment time. This gives the stack a working baseline
out of the box.

## Customizing the Keycloak configuration

Deployment-specific changes (extra users, extra groups, site-specific
clients) go into a single dedicated file:
`configs/keycloak-config/customizations.tf`.

**1. Create the file if it doesn't exist.**

```bash
touch configs/keycloak-config/customizations.tf
```

**2. Add your custom resources.** For example, to add a default user with a specific role:

```hcl
resource "keycloak_user" "default_user" {
  realm_id   = module.realms.realm_id
  username   = "alice"
  enabled    = true
  email      = "alice@example.org"
  # Set to true to skip email verification step on first login.
  email_verified = true 
  first_name = "Alice"
  last_name  = "Example"

  initial_password {
    value     = "alice"
    # Set to false to not force password change on first login.
    temporary = false
  }
}

# Assign roles to the user.
resource "keycloak_user_roles" "default_user_roles" {
  realm_id = module.realms.realm_id
  user_id  = keycloak_user.default_user.id
  # Example: assign the "annotator-access-role" from the realm roles.
  role_ids = [module.roles.realm_role_ids["annotator-access-role"]]
}
```

The root Terraform config exposes `module.realms`, `module.clients`,
`module.roles`, etc. — their outputs are available directly from
`customizations.tf`.

**3. Deploy/Re-apply.** To re-apply from the repository root:

```bash
docker compose up -d --force-recreate keycloak-config
```

## External identity providers

In addition to local Keycloak accounts, the stack supports two external
login options:

- **Google**.
- **Microsoft Azure**.

---
# 1. Google Authentication Setup

Google login can be enabled via environment configuration and is automatically configured in Keycloak during deployment.

## 1.1 Create Google OAuth Credentials

Detailed guide: [Google Api Guide for Manage OAuth Clients](https://support.google.com/cloud/answer/15549257?sjid=13971690791208954820-EU)

## 1.2 Configure Redirect URI

If running locally, add the following as an **Authorized Redirect URI**:
- `http://localhost:1235/services/auth/realms/record-manager/broker/google/endpoint`

Important ⚠️:

- The realm must be `record-manager`.
- The redirect URI must match exactly.
- ⚠️ If running on a domain, replace `localhost:1235` with your domain.

You will receive:

- **Client ID**
- **Client Secret**
---

## 1.3 Environment Variables

Enable Google login in `.env`:

```bash
ENABLE_GOOGLE_LOGIN=true
GOOGLE_CLIENT_ID=<your-client-id>
GOOGLE_CLIENT_SECRET=<your-client-secret>
```

If Google login should be disabled:
```bash
ENABLE_GOOGLE_LOGIN=false
```

# 2. Microsoft Azure Authentication Setup
Microsoft login can be configured similarly to Google, but in this deployment it is not automatically provisioned via Terraform.
It must be configured manually in the Keycloak Admin Console. Follow:
- [Official Microsoft Guide](https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-register-app)
- [Keycloak documentation for identity brokers](https://www.keycloak.org/docs/latest/server_admin/index.html#_identity_broker)