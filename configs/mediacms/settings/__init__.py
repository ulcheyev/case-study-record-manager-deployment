import os

profile = os.getenv("DJANGO_PROFILE", "prod")

print(f"[Settings] Loading profile: {profile}")

if profile == "dev":
    from .dev import *
elif profile == "prod":
    from .prod import *
else:
    raise RuntimeError(f"Unknown DJANGO_PROFILE: {profile}")