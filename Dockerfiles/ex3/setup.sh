#!/bin/bash
echo "Setting NGINX on $NGINX_PORT port..."
## Events brackets are required for nginx to start, so we add it to the config file
nginx_configuration="$(sed -E "s/(listen\s+)[0-9]{1,5};/\1${NGINX_PORT};/g" "/app/nginx/data/nginx.conf")"
echo "$nginx_configuration" > /app/nginx/data/nginx.conf