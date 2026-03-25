print("[DEV PROFILE LOADED]")

DEBUG = True

# Disable auth completely
USE_IDENTITY_PROVIDERS = False
USE_RBAC = False
GLOBAL_LOGIN_REQUIRED = False

LOGIN_URL = None
LOGIN_REDIRECT_URL = "/"
LOGOUT_REDIRECT_URL = "/"

# Remove protected media middleware if present
MIDDLEWARE = [
    m for m in MIDDLEWARE
    if "ProtectedMediaMiddleware" not in m
]

MIDDLEWARE += [
    "deploy.docker.dev_auth.DevAutoLoginMiddleware",
]

# Disable OIDC completely
SOCIALACCOUNT_PROVIDERS = {}
SOCIALACCOUNT_ADAPTER = "allauth.socialaccount.adapter.DefaultSocialAccountAdapter"