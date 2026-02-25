FROM mediacms/mediacms:7.2

COPY ./images/userlogos /home/mediacms.io/mediacms/media_files/userlogos
COPY ./local_settings.py /home/mediacms.io/mediacms/deploy/docker/local_settings.py
COPY ./nginx.conf /home/mediacms.io/mediacms/deploy/docker/nginx_http_only.conf
COPY ./oidc_adapter.py /home/mediacms.io/mediacms/deploy/docker/oidc_adapter.py

