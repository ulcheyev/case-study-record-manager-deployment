from allauth.socialaccount.adapter import DefaultSocialAccountAdapter
from django.core.exceptions import PermissionDenied
from django.conf import settings


class RoleRestrictedSocialAccountAdapter(DefaultSocialAccountAdapter):

    def pre_social_login(self, request, sociallogin):

        claims = sociallogin.account.extra_data or {}
        roles = claims.get("realm_access", {}).get("roles", [])

        if settings.MEDIACMS_REQUIRED_ROLE not in roles:
            raise PermissionDenied(
                f"Access denied. Missing role: {settings.MEDIACMS_REQUIRED_ROLE}"
            )
