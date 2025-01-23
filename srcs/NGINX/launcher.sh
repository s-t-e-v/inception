#!/bin/bash

service nginx start
service nginx status
nginx -g 'daemon off;'