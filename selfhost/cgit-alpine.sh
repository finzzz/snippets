#! /bin/sh

apk add cgit git spawn-fcgi fcgiwrap openrc nginx

mkdir -p /var/lib/git/repositories/public
echo -e "virtual-root=/\nscan-path=/var/lib/git/repositories/public" > /etc/cgitrc

ln -s spawn-fcgi /etc/init.d/spawn-fcgi.trac
cp /etc/conf.d/spawn-fcgi /etc/conf.d/spawn-fcgi.trac
sed -ie "s/#FCGI_PORT=/FCGI_PORT=1234/" /etc/conf.d/spawn-fcgi.trac
sed -ie "s/#FCGI_PROGRAM=/FCGI_PROGRAM=\/usr\/bin\/fcgiwrap/" /etc/conf.d/spawn-fcgi.trac

# nginx config
echo "server {
    root /usr/share/webapps/cgit;
    try_files $uri @cgit;

    rewrite ^/$ /cgit/ last;
    rewrite ^/(\S*)/(.*)$ /cgit/$1/$2 last;

    location @cgit {
        include fastcgi_params;
        fastcgi_pass localhost:1234;
        fastcgi_param SCRIPT_FILE $document_root/cgit.cgi;
        fastcgi_param PATH_INFO $uri;
        fastcgi_param QUERY_STRING $args;
    }
}" > /etc/nginx/conf.d/default.conf

rc-update add nginx
rc-update add spawn-fcgi.trac

rc-service spawn-fcgi.trac start
rc-service nginx start