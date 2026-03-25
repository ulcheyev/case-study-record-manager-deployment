from .base import *

DEBUG = False

GLOBAL_LOGIN_REQUIRED = True

LOGIN_URL = "/accounts/oidc/keycloak/login/"
LOGIN_REDIRECT_URL = "/"
LOGOUT_REDIRECT_URL = "/accounts/oidc/keycloak/login/"

# Enable protected media
MIDDLEWARE = MIDDLEWARE + [
    'deploy.docker.protected_media.ProtectedMediaMiddleware',
]

print("[Settings] PROD loaded")