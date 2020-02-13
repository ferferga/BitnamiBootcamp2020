#!/bin/bash
## Sets up listening port based in environment variables
/scripts/setup.sh
exec "$@"
