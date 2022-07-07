#!/bin/bash

## Sets up listening port based in environment variables
if [[ "$*" = "/scripts/run.sh" ]]; then
    echo "==== Starting CKAN setup ===="
    /scripts/setup.sh
    echo "==== CKAN setup finished! ===="
fi
exec "$@"