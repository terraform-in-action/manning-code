#!/bin/bash
rm /var/www/html/index.nginx-debian.html
sed -i "s/\${BG_COLOR}/${BG_COLOR}/" /var/www/html/index.html
sed -i "s/\${NAME}/${NAME}/g" /var/www/html/index.html
rm /etc/nginx/sites-available/default
rm /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/webserver.conf /etc/nginx/sites-enabled/webserver.conf
service nginx restart
sleep infinity