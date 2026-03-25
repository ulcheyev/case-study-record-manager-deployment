from django.contrib.auth import get_user_model, login

class DevAutoLoginMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        if not request.user.is_authenticated:
            User = get_user_model()

            user, _ = User.objects.get_or_create(
                username="dev",
                defaults={
                    "is_staff": True,
                    "is_superuser": True,
                }
            )

            if not user.is_staff or not user.is_superuser:
                user.is_staff = True
                user.is_superuser = True
                user.save()

            login(request, user)

        return self.get_response(request)