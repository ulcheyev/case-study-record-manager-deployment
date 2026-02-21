from allauth.socialaccount.adapter import DefaultSocialAccountAdapter
from django.core.exceptions import PermissionDenied
from django.conf import settings
import logging
logger = logging.getLogger(__name__)

class RoleRestrictedSocialAccountAdapter(DefaultSocialAccountAdapter):
    def pre_social_login(self, request, sociallogin):

        claims = sociallogin.account.extra_data or {}
        roles = claims.get("realm_access", {}).get("roles", [])

        print(claims)

        if settings.MEDIACMS_REQUIRED_ROLE not in roles:
            logger.warning(
                "[Access denied] User %s missing required role '%s'.",
                claims.get("preferred_name"),
                settings.MEDIACMS_REQUIRED_ROLE,
            )
            raise PermissionDenied(
                f"Access denied. Missing role: {settings.MEDIACMS_REQUIRED_ROLE}"
            )
