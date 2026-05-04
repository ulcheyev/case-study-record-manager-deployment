# Reverse Proxy Configuration for MediaCMS

When MediaCMS is deployed behind a reverse proxy, the OIDC login
redirect URI may be constructed incorrectly pointing to `localhost` or an internal
hostname instead of the public URL. The reverse proxy must forward the original `Host` header to the MediaCMS container.

### Apache

Add `ProxyPreserveHost On` to the VirtualHost block that proxies MediaCMS:

```apache
<VirtualHost *:<port>>
    #...
    ProxyPreserveHost On
    ProxyPass / http://127.0.0.1:<port>/
    ProxyPassReverse / http://127.0.0.1:<port>/
    #...
</VirtualHost>
```

### Nginx

Add `proxy_set_header Host` to the location block that proxies MediaCMS:

```nginx
location / {
    #...
    proxy_pass http://127.0.0.1:<port>;
    proxy_set_header Host $http_host;
    #...
}
```
