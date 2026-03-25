import os
import time
from .settings import *

ENV = os.getenv("DJANGO_ENV", "prod")
print(f"[local_settings] ENV = {ENV}")

# ========================
# DATABASE
# ========================
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

# ========================
# REDIS / CELERY
# ========================
REDIS_LOCATION = os.getenv('REDIS_LOCATION', 'redis://redis:6379/1')

CACHES = {
    "default": {
        "BACKEND": "django_redis.cache.RedisCache",
        "LOCATION": REDIS_LOCATION,
        "OPTIONS": {
            "CLIENT_CLASS": "django_redis.client.DefaultClient",
        },
    }
}
BROKER_URL = REDIS_LOCATION
CELERY_RESULT_BACKEND = REDIS_LOCATION


# ========================
# COMMON
# ========================
DO_NOT_TRANSCODE_VIDEO = os.getenv('DO_NOT_TRANSCODE_VIDEO', 'False') == 'True'
MP4HLS_COMMAND = "/home/mediacms.io/bento4/bin/mp4hls"
FRONTEND_HOST = os.getenv('FRONTEND_HOST', 'http://localhost')
PORTAL_NAME = os.getenv('PORTAL_NAME', 'MediaCMS')
REGISTER_ALLOWED = False

# ========================
# PROFILE DEFINITIONS
# ========================

def dev_config():
    print("[local_settings] Running in DEV mode")

    middleware = [
        m for m in MIDDLEWARE
        if m != 'deploy.docker.protected_media.ProtectedMediaMiddleware'
    ]

    middleware.append("deploy.docker.dev_auth.DevAutoLoginMiddleware")

    return {
        "DEBUG": True,
        "USE_IDENTITY_PROVIDERS": False,
        "USE_RBAC": False,
        "GLOBAL_LOGIN_REQUIRED": False,
        "LOGIN_URL": "/",
        "LOGIN_REDIRECT_URL": "/",
        "LOGOUT_REDIRECT_URL": "/",
        "MIDDLEWARE": middleware,
        "INSTALLED_APPS": [
            app for app in INSTALLED_APPS
            if app != "allauth.socialaccount.providers.openid_connect"
        ],
    }


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


def prod_config():
    print("[local_settings] Running in PROD mode")

    oidc_secret = read_secret()

    middleware = list(MIDDLEWARE)
    if 'deploy.docker.protected_media.ProtectedMediaMiddleware' not in middleware:
        middleware.append('deploy.docker.protected_media.ProtectedMediaMiddleware')

    return {
        "DEBUG": os.getenv('DEBUG', 'False') == 'True',
        "USE_IDENTITY_PROVIDERS": True,
        "USE_RBAC": True,
        "GLOBAL_LOGIN_REQUIRED": True,
        "LOGIN_URL": "/accounts/oidc/keycloak/login/",
        "LOGIN_REDIRECT_URL": "/",
        "LOGOUT_REDIRECT_URL": "/accounts/oidc/keycloak/login/",
        "INSTALLED_APPS": INSTALLED_APPS + [
            "allauth.socialaccount.providers.openid_connect",
        ],
        "MIDDLEWARE": middleware,
        "SOCIALACCOUNT_PROVIDERS": {
            "openid_connect": {
                "APPS": [
                    {
                        "provider_id": "keycloak",
                        "name": "Keycloak",
                        "client_id": "mediacms",
                        "secret": oidc_secret,
                        "settings": {
                            "server_url": os.getenv(
                                "OIDC_SERVER_URL",
                                "http://auth-server:8080/realms/record-manager/.well-known/openid-configuration",
                            ),
                        },
                    }
                ]
            }
        },
        "SOCIALACCOUNT_ADAPTER": "deploy.docker.oidc_adapter.RoleRestrictedSocialAccountAdapter",
        "MEDIACMS_REQUIRED_ROLE": os.getenv(
            "MEDIACMS_REQUIRED_ROLE",
            "mediacms-access-role"
        )
    }


# ========================
# PROFILE DISPATCH
# ========================

PROFILES = {
    "dev": dev_config,
    "prod": prod_config,
}

if ENV not in PROFILES:
    raise RuntimeError(f"Unknown DJANGO_ENV: {ENV}")

config = PROFILES[ENV]()
globals().update(config)

