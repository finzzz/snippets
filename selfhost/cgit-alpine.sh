#! /bin/sh

GLOBAL_OWNER="Vincent Carlos"

apk add cgit git spawn-fcgi fcgiwrap openrc nginx python3 py3-pip openssl
pip3 install markdown pygments

# comment this out if self-signed cert is not needed
openssl req -x509 -nodes -sha256 -subj "/CN=localhost" -newkey rsa:4096 \
            -keyout /etc/ssl/selfsigned.key -out /etc/ssl/selfsigned.cert -days 3650
apk del openssl

git config --global gitweb.owner "$GLOBAL_OWNER"
git config --global gitweb.description "add description: git config gitweb.description \"my description\""

mkdir -p /var/lib/git/repositories/public

# order matters
echo "root-title=Cool Title
root-desc=Fully Open Source
about-filter=/usr/lib/cgit/filters/about-formatting.sh
source-filter=/usr/lib/cgit/filters/syntax-highlighting.py
readme=:README.md
snapshots=tar.xz
enable-commit-graph=1
enable-index-links=1
enable-git-config=1
remove-suffix=1
virtual-root=/
scan-path=/var/lib/git/repositories/public
logo=
footer=notexistfooter.txt" > /etc/cgitrc

ln -s spawn-fcgi /etc/init.d/spawn-fcgi.trac
cp /etc/conf.d/spawn-fcgi /etc/conf.d/spawn-fcgi.trac
sed -ie "s/#FCGI_PORT=/FCGI_PORT=1234/" /etc/conf.d/spawn-fcgi.trac
sed -ie "s/#FCGI_PROGRAM=/FCGI_PROGRAM=\/usr\/bin\/fcgiwrap/" /etc/conf.d/spawn-fcgi.trac

# nginx config
echo "ssl_certificate         /etc/ssl/selfsigned.cert;
ssl_certificate_key     /etc/ssl/selfsigned.key;

server {
    listen 443 ssl;
    listen [::]:443 ssl;

    root /usr/share/webapps/cgit;
    try_files \$uri @cgit;

    rewrite ^/\$ /cgit/ last;
    rewrite ^/(\S*)/(.*)\$ /cgit/\$1/\$2 last;

    location @cgit {
        include fastcgi_params;
        fastcgi_pass localhost:1234;
        fastcgi_param SCRIPT_FILE \$document_root/cgit.cgi;
        fastcgi_param PATH_INFO \$uri;
        fastcgi_param QUERY_STRING \$args;
    }
}" > /etc/nginx/conf.d/default.conf

rc-update add nginx
rc-update add spawn-fcgi.trac

rc-service spawn-fcgi.trac start
rc-service nginx start

echo "To change the coloring style, modify the style argument that is passed to HtmlFormatter in the syntax-highlighting.py file."
echo "formatter = HtmlFormatter(encoding='utf-8', style='tango')"
python3 -c "from pygments.styles import get_all_styles;print(list(get_all_styles()))" # available styles