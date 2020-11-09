1. Package
```
apk add openrc openssl nginx nginx-mod-http-dav-ext
```

2. Make path dir
```
mkdir -p /etc/nginx/conf.d/path
mkdir -p /var/www/webdav/.temp
```

3. Nginx config
```
ssl_certificate     /etc/ssl/selfsigned.cert;
ssl_certificate_key /etc/ssl/selfsigned.key;

# PUT : upload
# MKCOL : make folder
# COPY : duplicate source

server {
    listen 443 ssl;
    server_name _;
    root                    /var/www/webdav;        # check permission
    client_body_temp_path   /var/www/webdav/.temp;
    client_max_body_size    1G;                     # new file size limit

    auth_basic              "Auth Needed";
    auth_basic_user_file    /var/www/htpasswd;

    dav_ext_methods PROPFIND OPTIONS;
    dav_access      user:rw group:rw all:r;
    create_full_put_path    on;
    autoindex on;

    include /etc/nginx/conf.d/path/*;
}
```

4. Create Path
/etc/nginx/conf.d/path/root
```
location / {
    dav_methods             PUT DELETE MKCOL COPY MOVE;
    auth_basic_user_file    /var/www/htpasswd/username;
}
```

5. Create password
```
openssl passwd -apr1 supersecret
```

6. htpasswd content
```
username:passwordhash
```

7. SSL Certs
```
openssl req -x509 -nodes -sha256 -subj "/CN=localhost" -newkey rsa:4096 -keyout selfsigned.key -out selfsigned.cert -days 3650
```

8. Start & enable
```
rc-update add nginx
rc-service nginx start
```

9. (optional) add user & path
adduser.sh uname pass "PUT DELETE"
```
#! /bin/sh

# add_user.sh john pass "PUT DELETE"
root="/var/www/webdav/"
creds_folder="/var/www/htpasswd/"
conf="/etc/nginx/conf.d/path/"

mkdir -p "$root$1" && chown -R nginx: "$root$1"
echo "$1:$(openssl passwd -apr1 $2)" > "$creds_folder$1"
echo "location /$1 {" > "$conf$1"
if [[ "$3" ]]; then
    echo -e "\tdav_methods\t$3;" >> "$conf$1"
else
    echo -e "\tdav_methods\tPUT DELETE MKCOL COPY MOVE;" >> "$conf$1"
fi
echo -e "\tauth_basic_user_file\t/var/www/htpasswd/$1;" >> "$conf$1"
echo "}" >> "$conf$1"
nginx -s reload
```
