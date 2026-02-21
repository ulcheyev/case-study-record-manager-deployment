import os
from .settings import *
import time

FRONTEND_HOST = os.getenv('FRONTEND_HOST', 'http://localhost')
PORTAL_NAME = os.getenv('PORTAL_NAME', 'MediaCMS')
REDIS_LOCATION = os.getenv('REDIS_LOCATION', 'redis://redis:6379/1')

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "NAME": os.getenv('POSTGRES_NAME', 'record-manager'),
        "HOST": os.getenv('POSTGRES_HOST', 'postgres'),
        "PORT": os.getenv('POSTGRES_PORT', '5432'),
        "USER": os.getenv('POSTGRES_USER', 'mediacms'),
        "PASSWORD": os.getenv('POSTGRES_PASSWORD', 'mediacms'),
        "OPTIONS": {'pool': True},
    }
}

CACHES = {
    "default": {
        "BACKEND": "django_redis.cache.RedisCache",
        "LOCATION": REDIS_LOCATION,
        "OPTIONS": {
            "CLIENT_CLASS": "django_redis.client.DefaultClient",
        },
    }
}

# OID
USE_IDENTITY_PROVIDERS = True
USE_RBAC = True
INSTALLED_APPS = INSTALLED_APPS + [
    "allauth.socialaccount.providers.openid_connect",
]


def read_secret(
        path="/secrets/mediacms_client_secret",
        timeout=2000,
        interval=10,
):
    """
    Wait until secret file appears.
    Fails after timeout seconds.
    """

    start = time.time()

    while True:
        if os.path.exists(path):
            with open(path) as f:
                secret = f.read().strip()
                if secret:
                    print("Secrets injected...")
                    return secret

        if time.time() - start > timeout:
            raise RuntimeError(
                f"Secret file not found after {timeout} seconds: {path}"
            )
        # TODO exit 1

        print("Waiting for OIDC secret...")
        time.sleep(interval)


OIDC_SECRET = read_secret()
REGISTER_ALLOWED = False

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


GLOBAL_LOGIN_REQUIRED = True
LOGIN_URL = "/accounts/oidc/keycloak/login/"
LOGIN_REDIRECT_URL = "/"
LOGOUT_REDIRECT_URL = "/accounts/oidc/keycloak/login/"

SOCIALACCOUNT_ADAPTER = "deploy.docker.oidc_adapter.RoleRestrictedSocialAccountAdapter"
MEDIACMS_REQUIRED_ROLE = os.getenv(
    "MEDIACMS_REQUIRED_ROLE",
    "mediacms-access-role"
)

# CELERY STUFF
BROKER_URL = REDIS_LOCATION
CELERY_RESULT_BACKEND = BROKER_URL

MP4HLS_COMMAND = "/home/mediacms.io/bento4/bin/mp4hls"

DEBUG = os.getenv('DEBUG', 'False') == 'True'