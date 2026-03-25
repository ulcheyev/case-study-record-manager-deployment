import os
import time
from mediacms.settings import *

# ========================
# BASE
# ========================
FRONTEND_HOST = os.getenv('FRONTEND_HOST', 'http://localhost')
PORTAL_NAME = os.getenv('PORTAL_NAME', 'MediaCMS')

REDIS_LOCATION = os.getenv('REDIS_LOCATION', 'redis://redis:6379/1')

# 🔥 IMPORTANT: define DB early
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "NAME": os.getenv('POSTGRES_DB', 'record-manager'),
        "HOST": os.getenv('POSTGRES_HOST', 'postgres'),
        "PORT": os.getenv('POSTGRES_PORT', '5432'),
        "USER": os.getenv('POSTGRES_USER', 'mediacms'),
        "PASSWORD": os.getenv('POSTGRES_PASSWORD', 'mediacms'),
        "OPTIONS": {"pool": True},  # keep if needed
    }
}

# Force psycopg to behave (safety)
os.environ.setdefault("PGHOST", DATABASES["default"]["HOST"])
os.environ.setdefault("PGPORT", DATABASES["default"]["PORT"])

CACHES = {
    "default": {
        "BACKEND": "django_redis.cache.RedisCache",
        "LOCATION": REDIS_LOCATION,
        "OPTIONS": {
            "CLIENT_CLASS": "django_redis.client.DefaultClient",
        },
    }
}

# ========================
# CELERY
# ========================
BROKER_URL = REDIS_LOCATION
CELERY_RESULT_BACKEND = BROKER_URL

# ========================
# VIDEO
# ========================
DO_NOT_TRANSCODE_VIDEO = os.getenv('DO_NOT_TRANSCODE_VIDEO', 'False') == 'True'

MP4HLS_COMMAND = "/home/mediacms.io/bento4/bin/mp4hls"

# ========================
# OIDC BASE
# ========================
USE_IDENTITY_PROVIDERS = True
USE_RBAC = True

INSTALLED_APPS = INSTALLED_APPS + [
    "allauth.socialaccount.providers.openid_connect",
]

def read_secret(
        path="/secrets/mediacms_client_secret",
        timeout=1000,
        interval=5,
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

SOCIALACCOUNT_ADAPTER = "deploy.docker.oidc_adapter.RoleRestrictedSocialAccountAdapter"

MEDIACMS_REQUIRED_ROLE = os.getenv(
    "MEDIACMS_REQUIRED_ROLE",
    "mediacms-access-role"
)

REGISTER_ALLOWED = False