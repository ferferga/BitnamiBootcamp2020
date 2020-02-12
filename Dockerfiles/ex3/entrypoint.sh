#!/bin/bash

## Load NGINX environment variables
export PATH="/scripts:/app/nginx/bin:$PATH"

## Configures the default port based in variables
if [[ "$*" = "/scripts/run.sh" ]]; then
    echo "=== Starting NGINX configuration ==="
    /scripts/setup.sh
    echo "=== NGINX configuration finished! ==="
fi
echo " " && echo " " && echo " "
exec "$@"