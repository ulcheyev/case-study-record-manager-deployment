# Authentication Configuration 

Authentication is based on **OIDC (OpenID Connect)** and centrally managed by **Keycloak**.

---
# 1. Google Authentication Setup

Google login can be enabled via environment configuration and is automatically configured in Keycloak during deployment.

## 1.1 Create Google OAuth Credentials

Detailed guide: [Google Api Guide for OAuth](https://support.google.com/googleapi/answer/6158849?hl=en)

You will receive:

- **Client ID**
- **Client Secret**
---

## 1.2 Configure Redirect URI

If running locally, add the following as an **Authorized Redirect URI**:
- `http://localhost:1235/services/auth/realms/record-manager/broker/google/endpoint`

Important ⚠️:

- The realm must be `record-manager`.
- The redirect URI must match exactly.
- ⚠️ If running on a domain, replace `localhost:1235` with your domain.

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
- [Official Microsoft Guide](https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-register-app).
- [Keycloak documentation for identity brokers](https://www.keycloak.org/docs/latest/server_admin/index.html#_identity_broker)


