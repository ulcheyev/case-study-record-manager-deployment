FROM mediacms/mediacms:7.2

COPY ./images/userlogos /home/mediacms.io/mediacms/media_files/userlogos
COPY ./protected_media.py /home/mediacms.io/mediacms/deploy/docker/protected_media.py
COPY ./nginx.conf /home/mediacms.io/mediacms/deploy/docker/nginx_http_only.conf
COPY ./oidc_adapter.py /home/mediacms.io/mediacms/deploy/docker/oidc_adapter.py
COPY profiles /home/mediacms.io/mediacms/deploy/docker/settings
COPY ./dev_auth.py /home/mediacms.io/mediacms/deploy/docker/dev_auth.py