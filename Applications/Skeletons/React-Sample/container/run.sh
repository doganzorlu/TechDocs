#!/bin/sh
sed -i -e "s,NODE_APP_URL,$NODE_APP_URL,g" /etc/nginx/nginx.conf
nginx -g 'daemon off;'