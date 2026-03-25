import os
import time
from .settings import *
ENV = os.getenv("DJANGO_ENV", "prod")

print(f"[local_settings] ENV = {ENV}")

# ========================
# DATABASE (override safely)
# ========================
DATABASES["default"].update({
    "NAME": os.getenv("POSTGRES_NAME", "record-manager"),
    "HOST": os.getenv("POSTGRES_HOST", "postgres"),
    "PORT": os.getenv("POSTGRES_PORT", "5432"),
    "USER": os.getenv("POSTGRES_USER", "mediacms"),
    "PASSWORD": os.getenv("POSTGRES_PASSWORD", "mediacms"),
})

# ========================
# REDIS / CELERY
# ========================
REDIS_LOCATION = os.getenv('REDIS_LOCATION', 'redis://redis:6379/1')

CACHES["default"]["LOCATION"] = REDIS_LOCATION

BROKER_URL = REDIS_LOCATION
CELERY_RESULT_BACKEND = REDIS_LOCATION

# ========================
# DEV vs PROD SWITCH
# ========================

if ENV == "dev":
    print("[local_settings] Running in DEV mode")

    DEBUG = True

    # 🔓 Disable auth completely
    USE_IDENTITY_PROVIDERS = False
    USE_RBAC = False
    GLOBAL_LOGIN_REQUIRED = False

    LOGIN_URL = None
    LOGIN_REDIRECT_URL = "/"
    LOGOUT_REDIRECT_URL = "/"

    # ❌ remove protected media middleware if present
    MIDDLEWARE = [
        m for m in MIDDLEWARE
        if m != 'deploy.docker.protected_media.ProtectedMediaMiddleware'
    ]

    # ❌ remove OIDC app if present
    INSTALLED_APPS = [
        app for app in INSTALLED_APPS
        if app != "allauth.socialaccount.providers.openid_connect"
    ]

else:
    print("[local_settings] Running in PROD mode")

    DEBUG = os.getenv('DEBUG', 'False') == 'True'

    USE_IDENTITY_PROVIDERS = True
    USE_RBAC = True
    GLOBAL_LOGIN_REQUIRED = True

    LOGIN_URL = "/accounts/oidc/keycloak/login/"
    LOGIN_REDIRECT_URL = "/"
    LOGOUT_REDIRECT_URL = "/accounts/oidc/keycloak/login/"

    # ========================
    # SECRET LOADER (ONLY PROD)
    # ========================
    def read_secret(
            path="/secrets/mediacms_client_secret",
            timeout=2000,
            interval=10,
    ):
        start = time.time()

        while True:
            if os.path.exists(path):
                with open(path) as f:
                    secret = f.read().strip()
                    if secret:
                        print("[OIDC] Secret loaded")
                        return secret

            if time.time() - start > timeout:
                raise RuntimeError(f"Secret not found: {path}")

            time.sleep(interval)

    print("[OIDC] Waiting for secret...")
    OIDC_SECRET = read_secret()

    # ✅ enable OIDC
    INSTALLED_APPS = INSTALLED_APPS + [
        "allauth.socialaccount.providers.openid_connect",
    ]

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

    SOCIALACCOUNT_ADAPTER = "deploy.docker.oidc_adapter.RoleRestrictedSocialAccountAdapter"

    # ✅ enforce protected media
    if 'deploy.docker.protected_media.ProtectedMediaMiddleware' not in MIDDLEWARE:
        MIDDLEWARE.append(
            'deploy.docker.protected_media.ProtectedMediaMiddleware'
        )

# ========================
# COMMON
# ========================
DO_NOT_TRANSCODE_VIDEO = os.getenv('DO_NOT_TRANSCODE_VIDEO', 'False') == 'True'
MP4HLS_COMMAND = "/home/mediacms.io/bento4/bin/mp4hls"