#! /bin/sh

# TODO
# nginx port 443
# private repo routing + basic auth

apk add cgit git spawn-fcgi fcgiwrap openrc nginx python3 py3-pip
pip3 install markdown pygments

mkdir -p /var/lib/git/repositories/public

# order matters
echo "about-filter=/usr/lib/cgit/filters/about-formatting.sh
source-filter=/usr/lib/cgit/filters/syntax-highlighting.py
readme=:README.md   
snapshots=tar.xz                                       
virtual-root=/   
scan-path=/var/lib/git/repositories/public" > /etc/cgitrc

ln -s spawn-fcgi /etc/init.d/spawn-fcgi.trac
cp /etc/conf.d/spawn-fcgi /etc/conf.d/spawn-fcgi.trac
sed -ie "s/#FCGI_PORT=/FCGI_PORT=1234/" /etc/conf.d/spawn-fcgi.trac
sed -ie "s/#FCGI_PROGRAM=/FCGI_PROGRAM=\/usr\/bin\/fcgiwrap/" /etc/conf.d/spawn-fcgi.trac

# nginx config
echo "server {
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