# deploy/docker/settings/dev.py

from .base import *

DEBUG = True

# Disable auth
GLOBAL_LOGIN_REQUIRED = False

# Remove protected media middleware if exists
MIDDLEWARE = [
    m for m in MIDDLEWARE
    if m != 'deploy.docker.protected_media.ProtectedMediaMiddleware'
]

print("[Settings] DEV loaded")