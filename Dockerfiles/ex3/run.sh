#!/bin/bash
echo "Starting nginx..."
echo ""
exec /app/nginx/bin/nginx -c /app/nginx/data/nginx.conf -g 'daemon off;'