# Scaling MediaCMS with Docker Compose
# Coming Soon...
# TODO Diagram with worker, web, migrations, beat....
Web container
mediacms-web:
image: mediacms/mediacms:7.2
environment:
ENABLE_UWSGI: yes
ENABLE_NGINX: yes
ENABLE_CELERY_BEAT: no
ENABLE_CELERY_SHORT: no
ENABLE_CELERY_LONG: no
ENABLE_MIGRATIONS: no

Worker container
celery-worker:
image: mediacms/mediacms:7.2
environment:
ENABLE_UWSGI: no
ENABLE_NGINX: no
ENABLE_CELERY_BEAT: no
ENABLE_CELERY_SHORT: yes
ENABLE_CELERY_LONG: yes
ENABLE_MIGRATIONS: no


Migrations container (one-shot)
migrations:
environment:
ENABLE_MIGRATIONS: yes
ENABLE_UWSGI: no
ENABLE_NGINX: no
ENABLE_CELERY_SHORT: no
ENABLE_CELERY_LONG: no

docker compose up -d --scale mediacms-web=3 --scale celery-worker=4
If you scale web containers, they all must see the same:
/media_files
For real scaling:
Option A — NFS
Mount shared network filesystem.
Option B — S3 (Best)
Use S3 backend so containers are stateless.

