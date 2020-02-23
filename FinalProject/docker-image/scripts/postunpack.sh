#!/bin/bash
echo "Configuring environment for CKAN..."
## Creating CKAN config directory
mkdir -p $CKAN_CONF_PATH
## Adding the CKAN user that will manage the daemon
adduser --system --shell /bin/false --no-create-home --disabled-login --disabled-password --gecos "ckan user" --group ckan

## Creating configuration files
paster make-config ckan $CKAN_CONF_PATH/$CKAN_CONF_FILE
cp /src/ckan/ckan/config/supervisor-ckan-worker.conf /etc/supervisor/conf.d
ln -s /src/ckan/who.ini $CKAN_CONF_PATH/who.ini
mkdir -p $CKAN_STORAGE_PATH

## Set permissions
chown -R ckan:ckan $CKAN_CONF_PATH
chown -R ckan:ckan /src/ckan/
chown -R ckan:ckan $CKAN_STORAGE_PATH
chmod -R 550 $CKAN_CONF_PATH
chmod -R 550 /src/ckan/
chmod -R 550 $CKAN_STORAGE_PATH

## Symlinking logs to stdout and stderr
ln -sf /dev/stdout /var/log/supervisor/supervisord.log
ln -sf /dev/stdout /var/log/ckan-worker.log