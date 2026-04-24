# Authentication Configuration

Authentication is based on **OIDC (OpenID Connect)**, centrally managed by
**Keycloak**. Keycloak's realm, clients, roles, and groups are provisioned
by Terraform at deployment time. This gives the stack a working baseline
out of the box.
## Customizing the Keycloak configuration

Deployment-specific changes (extra users, extra groups, site-specific
clients) go into a dedicated directory:
`configs/keycloak-config/customizations/`. It is applied as a separate
Terraform root after the main configuration.

**1. Create a resource file.** For example, `resources.tf` to add a default
user assigned to the entry clerk role group:

```hcl
resource "keycloak_user" "default_user" {
  realm_id       = var.realm_id
  username       = "alice"
  enabled        = true
  email          = "alice@example.org"
  email_verified = true
  first_name     = "Alice"
  last_name      = "Example"

  initial_password {
    value     = "alice"
    temporary = false
  }
}

data "keycloak_group" "default_user_group" {
  realm_id = var.realm_id
  name     = "entry-clerk-role-group"
}

resource "keycloak_user_groups" "default_user_groups" {
  realm_id  = var.realm_id
  user_id   = keycloak_user.default_user.id
  group_ids = [data.keycloak_group.default_user_group.id]
}
```

The customizations root exposes `var.realm_id`. Existing Keycloak resources
(roles, groups, clients) can be referenced through `data` sources as shown
above.

### How variables are wired
The customizations root declares its own `variables.tf` with the same
variables from `/config/keycloak-config/variables.tf` it needs.
To add a new input, declare it in `customizations/variables.tf`.

**2. Deploy/Re-apply.** To re-apply from the repository root:

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