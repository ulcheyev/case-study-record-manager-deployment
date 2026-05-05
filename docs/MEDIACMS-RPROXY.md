# Reverse Proxy Configuration for MediaCMS

When MediaCMS is deployed behind a reverse proxy, the OIDC login
redirect URI may be constructed incorrectly pointing to `localhost` or an internal
hostname instead of the public URL. The reverse proxy must forward the original `Host` header to the MediaCMS container.

### Apache

1. #### HTTP:
```apache
<VirtualHost *:<port>>
    ProxyPreserveHost On

    ProxyPass / http://127.0.0.1:<port>/
    ProxyPassReverse / http://127.0.0.1:<port>/
</VirtualHost>
```

2. #### HTTPS - also add SSL configuration and the `X-Forwarded-Proto` header:
```apache
<VirtualHost *:<port>>
    SSLEngine on
    SSLCertificateFile /path/to/certificate.crt
    SSLCertificateKeyFile /path/to/private.key

    ProxyPreserveHost On
    RequestHeader set X-Forwarded-Proto "https"

    ProxyPass / http://127.0.0.1:<port>/
    ProxyPassReverse / http://127.0.0.1:<port>/
</VirtualHost>
```

### Nginx

1. #### HTTP:
```nginx
location / {
    proxy_pass http://127.0.0.1:<port>;
    proxy_set_header Host $http_host;
}
```

2. #### HTTPS — also forward the protocol:
```nginx
location / {
    proxy_pass http://127.0.0.1:<port>;
    proxy_set_header Host $http_host;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```