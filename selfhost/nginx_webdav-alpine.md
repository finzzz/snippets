1. Package
```
apk add openrc openssl nginx nginx-mod-http-dav-ext
```

2. Nginx config
```
ssl_certificate     /etc/ssl/selfsigned.cert;
ssl_certificate_key /etc/ssl/selfsigned.key;

server {
    listen 443;
    server_name _;
    root                    /var/www/webdav;        # check permission
    client_body_temp_path   /var/www/webdav/.temp;
    client_max_body_size    1G;                     # new file size limit

    auth_basic              "Auth Needed";
    auth_basic_user_file    /var/www/htpasswd;

    dav_methods     PUT DELETE MKCOL COPY MOVE;
    dav_ext_methods PROPFIND OPTIONS;
    dav_access      user:rw group:rw all:r;
    create_full_put_path    on;
    autoindex on;
}
```

3. Create password
```
openssl passwd -apr1 supersecret
```

4. htpasswd content
```
username:passwordhash
```

5. SSL Certs
```
openssl req -x509 -nodes -sha256 -subj "/CN=localhost" -newkey rsa:4096 -keyout selfsigned.key -out selfsigned.cert -days 3650 
```

6. Start & enable
```
rc-update add nginx
rc-service nginx start
```