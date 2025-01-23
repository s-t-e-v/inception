#!/bin/bash

# nginx.conf is in /etc/nginx/
ls /etc/nginx/
cat /etc/nginx/nginx.conf
service nginx start
service nginx status
nginx -g 'daemon off;'