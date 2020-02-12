#!/bin/bash
echo "Starting nginx..."
exec /app/nginx/bin/nginx -c /app/nginx/data/nginx.conf -g 'daemon off;'