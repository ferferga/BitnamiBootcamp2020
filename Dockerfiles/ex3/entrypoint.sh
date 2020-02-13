#!/bin/bash

## Sets up listening port based in environment variables
if [[ "$*" = "/scripts/run.sh" ]]; then
    echo "==== Starting NGINX setup ===="
    /scripts/setup.sh
    echo "==== NGINX setup finished! ===="
fi
exec "$@"