import os

print("[PROD PROFILE LOADED]")

DEBUG = False

# Enable auth
USE_IDENTITY_PROVIDERS = True
USE_RBAC = True
GLOBAL_LOGIN_REQUIRED = True

LOGIN_URL = "/accounts/oidc/keycloak/login/"
LOGIN_REDIRECT_URL = "/"
LOGOUT_REDIRECT_URL = "/accounts/oidc/keycloak/login/"

REGISTER_ALLOWED = False

# Add OIDC provider
INSTALLED_APPS += [
    "allauth.socialaccount.providers.openid_connect",
]

print("[OIDC] Waiting for secret...")
OIDC_SECRET = read_secret()

SOCIALACCOUNT_PROVIDERS = {
    "openid_connect": {
        "APPS": [
            {
                "provider_id": "keycloak",
                "name": "Keycloak",
                "client_id": "mediacms",
                "secret": OIDC_SECRET,
                "settings": {
                    "server_url": os.getenv(
                        "OIDC_SERVER_URL",
                        "http://auth-server:8080/realms/record-manager/.well-known/openid-configuration",
                    ),
                },
            }
        ]
    }
}

# Protected media ON
MIDDLEWARE += [
    "deploy.docker.protected_media.ProtectedMediaMiddleware",
]

SOCIALACCOUNT_ADAPTER = (
    "deploy.docker.oidc_adapter.RoleRestrictedSocialAccountAdapter"
)

MEDIACMS_REQUIRED_ROLE = os.getenv(
    "MEDIACMS_REQUIRED_ROLE",
    "mediacms-access-role"
)