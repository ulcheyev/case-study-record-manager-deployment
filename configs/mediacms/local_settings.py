import os
from .settings import *
import time

# ========================
# PROFILE LOADER
# ========================
PROFILE = os.getenv("DJANGO_PROFILE", "prod")

print(f"[Settings] Loading profile: {PROFILE}")

if PROFILE == "dev":
    from .profiles.dev import *
elif PROFILE == "prod":
    from .profiles.prod import *
else:
    raise RuntimeError(f"Unknown DJANGO_PROFILE: {PROFILE}")

# ========================
# BASE
# ========================

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

# ========================
# CELERY
# ========================
BROKER_URL = REDIS_LOCATION
CELERY_RESULT_BACKEND = BROKER_URL

# ========================
# VIDEO
# ========================
DO_NOT_TRANSCODE_VIDEO = os.getenv('DO_NOT_TRANSCODE_VIDEO', 'False') == 'True'

# ========================
# SECRET LOADER
# ========================
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
            print(f"[OIDC] Secret not found after {timeout}s: {path}")
            sys.exit(1)

        time.sleep(interval)

