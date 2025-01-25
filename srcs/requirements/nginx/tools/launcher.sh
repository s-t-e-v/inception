#!/bin/bash

# nginx.conf is in /etc/nginx/
# ls /
# echo "---"
# ls /app/
# echo "---"
# ls /etc/nginx/
# echo "---"
# ls /var
# echo "---"
ls /var/www/sbandaog.42.fr
echo "---"
cat /var/www/sbandaog.42.fr/index.html
echo "---"
cat /etc/nginx/nginx.conf
echo "---"
nginx -g 'daemon off;'