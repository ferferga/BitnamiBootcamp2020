#!/bin/bash

echo "Configuring environment for nginx..."
## Symlinking our custom path with the generic path for avoiding confusion in our end
mkdir -p /etc/nginx
ln -s /app/nginx/lib/modules /etc/nginx/modules
## Adding a nginx user that will manage the daemon
adduser --system --shell /bin/false --no-create-home --disabled-login --disabled-password --gecos "nginx user" --group nginx
## Creating cache directories
mkdir -p /var/cache/nginx/client_temp /var/cache/nginx/fastcgi_temp /var/cache/nginx/proxy_temp /var/cache/nginx/scgi_temp /var/cache/nginx/uwsgi_temp
chmod 700 /var/cache/nginx/*
chown nginx:root /var/cache/nginx/*
chown nginx:root -R /app/nginx/data
## Symlinking logs to stdout and stderr
ln -sf /dev/stdout /app/nginx/data/logs/access.log
ln -sf /dev/stderr /app/nginx/data/logs/error.log
## Set environment variable
export PATH="/app/nginx/bin:$PATH"