#!/bin/bash
set -o errexit
export DEBIAN_FRONTEND="noninteractive"
echo "Setting CKAN configuration..."
## Database setup in the config file:
ckan_configuration="$(sed -E "s^sqlalchemy.url =.*^sqlalchemy.url = postgresql://$POSTGRESQL_DATABASE_USER:$POSTGRESQL_DATABASE_USER_PASSWORD@$POSTGRESQL_HOST:$POSTGRESQL_PORT/$POSTGRESQL_CKAN_DATABASE^g" "$CKAN_CONF_PATH/$CKAN_CONF_FILE")"
echo "$ckan_configuration" > $CKAN_CONF_PATH/$CKAN_CONF_FILE
## CKAN site ID configuration
ckan_id_configuration="$(sed -E "s^ckan.site_id =.*^ckan.site_id = $CKAN_SITE_ID^g" "$CKAN_CONF_PATH/$CKAN_CONF_FILE")"
echo "$ckan_id_configuration" > $CKAN_CONF_PATH/$CKAN_CONF_FILE
## CKAN URL configuration
ckan_url_configuration="$(sed -E "s^ckan.site_url =.*^ckan.site_url = http://$CKAN_HOST:$CKAN_PORT^g" "$CKAN_CONF_PATH/$CKAN_CONF_FILE")"
echo "$ckan_url_configuration" > $CKAN_CONF_PATH/$CKAN_CONF_FILE
## CKAN plugin configuration
ckan_plugin_configuration="$(sed -E "s^ckan.plugins =.*^ckan.plugins = $CKAN_PLUGINS^g" "$CKAN_CONF_PATH/$CKAN_CONF_FILE")"
echo "$ckan_plugin_configuration" > $CKAN_CONF_PATH/$CKAN_CONF_FILE
## CKAN SOLR configuration
ckan_solr_configuration="$(sed -E "s^#solr_url =.*^solr_url = http://$SOLR_URL/$SOLR_CORE_NAME^g" "$CKAN_CONF_PATH/$CKAN_CONF_FILE")"
echo "$ckan_solr_configuration" > $CKAN_CONF_PATH/$CKAN_CONF_FILE
## CKAN Storage Path
ckan_storage_configuration="$(sed -E "s^#ckan.storage_path =.*^ckan.storage_path = $CKAN_STORAGE_PATH^g" "$CKAN_CONF_PATH/$CKAN_CONF_FILE")"
echo "$ckan_storage_configuration" > $CKAN_CONF_PATH/$CKAN_CONF_FILE
## CKAN REDIS setup
ckan_redis_configuration="$(sed -E "s^#ckan.redis.url =.*^ckan.redis.url = redis://$REDIS_USER:$REDIS_PASSWORD@$REDIS_URL/0^g" "$CKAN_CONF_PATH/$CKAN_CONF_FILE")"
echo "$ckan_redis_configuration" > $CKAN_CONF_PATH/$CKAN_CONF_FILE
## CKAN port configuration
ckan_port_configuration="$(sed -E "s^port =.*^port = $CKAN_PORT^g" "$CKAN_CONF_PATH/$CKAN_CONF_FILE")"
echo "$ckan_port_configuration" > $CKAN_CONF_PATH/$CKAN_CONF_FILE
## Setting PostgreSQL
echo ""

if [ "$CKAN_INITIALIZE_DB" == "yes" ]; then
echo "Configuring PostgreSQL for first run..."
    while ! pg_isready -h $POSTGRESQL_HOST -p $POSTGRESQL_PORT; do
        echo "Connection to PostgreSQL failed... Sleeping 30 seconds before retrying"
        sleep 30
    done
    echo "PostgreSQL ready, populating database..."
    export PGUSER="$POSTGRESQL_ROOT_USER"
    export PGPASSWORD="$POSTGRESQL_ROOT_PASSWORD"
    createuser -h $POSTGRESQL_HOST -p $POSTGRESQL_PORT -U $POSTGRESQL_ROOT_USER -S -D -R $POSTGRESQL_DATABASE_USER
    psql -h $POSTGRESQL_HOST -p $POSTGRESQL_PORT -U $POSTGRESQL_ROOT_USER -c "ALTER USER $POSTGRESQL_DATABASE_USER WITH PASSWORD '$POSTGRESQL_DATABASE_USER_PASSWORD'"
    createdb -h $POSTGRESQL_HOST -p $POSTGRESQL_PORT -U $POSTGRESQL_ROOT_USER -O $POSTGRESQL_DATABASE_USER $POSTGRESQL_CKAN_DATABASE -E utf-8
    if [[ "$CKAN_PLUGINS" == *"datastore"* ]]; then
        echo ""
        echo "Configuring datastore with PostgreSQL..."
        createuser -h $POSTGRESQL_HOST -p $POSTGRESQL_PORT -U $POSTGRESQL_ROOT_USER -S -D -R -l $POSTGRESQL_DATASTORE_USER
        psql -h $POSTGRESQL_HOST -p $POSTGRESQL_PORT -U $POSTGRESQL_ROOT_USER -c "ALTER USER $POSTGRESQL_DATASTORE_USER WITH PASSWORD '$POSTGRESQL_DATASTORE_USER_PASSWORD'"
        createdb -h $POSTGRESQL_HOST -p $POSTGRESQL_PORT -U $POSTGRESQL_ROOT_USER -O $POSTGRESQL_DATABASE_USER $POSTGRESQL_CKAN_DATASTORE -E utf-8
        ## CKAN datastore configuration
        ckan_read_datastore_configuration="$(sed -E "s^#ckan.datastore.read_url =.*^ckan.datastore.read_url = postgresql://$POSTGRESQL_DATASTORE_USER:$POSTGRESQL_DATASTORE_USER_PASSWORD@$POSTGRESQL_HOST:$POSTGRESQL_PORT/$POSTGRESQL_CKAN_DATASTORE^g" "$CKAN_CONF_PATH/$CKAN_CONF_FILE")"
        echo "$ckan_read_datastore_configuration" > $CKAN_CONF_PATH/$CKAN_CONF_FILE
        ckan_write_datastore_configuration="$(sed -E "s^#ckan.datastore.write_url =.*^ckan.datastore.write_url = postgresql://$POSTGRESQL_DATABASE_USER:$POSTGRESQL_DATABASE_USER_PASSWORD@$POSTGRESQL_HOST:$POSTGRESQL_PORT/$POSTGRESQL_CKAN_DATASTORE^g" "$CKAN_CONF_PATH/$CKAN_CONF_FILE")"
        echo "$ckan_write_datastore_configuration" > $CKAN_CONF_PATH/$CKAN_CONF_FILE
        ## Permission set
        paster --plugin=ckan datastore set-permissions -c $CKAN_CONF_PATH/$CKAN_CONF_FILE | psql -U $POSTGRESQL_ROOT_USER -h $POSTGRESQL_HOST -p $POSTGRESQL_PORT --set ON_ERROR_STOP=1
    fi    
    export PGUSER="$POSTGRESQL_DATABASE_USER"
    export PGPASSWORD="$POSTGRESQL_DATABASE_USER_PASSWORD"
    paster --plugin=ckan db init -c $CKAN_CONF_PATH/$CKAN_CONF_FILE
    ## CKAN user setup
    echo ""
    echo "Setting up CKAN users..."
    paster --plugin=ckan user add $CKAN_ADMIN email="$CKAN_ADMIN_EMAIL" password="$CKAN_ADMIN_PASSWORD" --config=$CKAN_CONF_PATH/$CKAN_CONF_FILE
    paster --plugin=ckan sysadmin add $CKAN_ADMIN --config=$CKAN_CONF_PATH/$CKAN_CONF_FILE
    ckan_mail_configuration="$(sed -E "s^#smtp.user =.*^smtp.user = $CKAN_ADMIN_EMAIL^g" "$CKAN_CONF_PATH/$CKAN_CONF_FILE")"
    echo "$ckan_mail_configuration" > $CKAN_CONF_PATH/$CKAN_CONF_FILE
else
    if [[ "$CKAN_PLUGINS" == *"datastore"* ]]; then
        ckan_read_datastore_configuration="$(sed -E "s^#ckan.datastore.read_url =.*^ckan.datastore.read_url = postgresql://$POSTGRESQL_DATASTORE_USER:$POSTGRESQL_DATASTORE_USER_PASSWORD@$POSTGRESQL_HOST:$POSTGRESQL_PORT/$POSTGRESQL_CKAN_DATASTORE^g" "$CKAN_CONF_PATH/$CKAN_CONF_FILE")"
        echo "$ckan_read_datastore_configuration" > $CKAN_CONF_PATH/$CKAN_CONF_FILE
        ckan_write_datastore_configuration="$(sed -E "s^#ckan.datastore.write_url =.*^ckan.datastore.write_url = postgresql://$POSTGRESQL_DATABASE_USER:$POSTGRESQL_DATABASE_USER_PASSWORD@$POSTGRESQL_HOST:$POSTGRESQL_PORT/$POSTGRESQL_CKAN_DATASTORE^g" "$CKAN_CONF_PATH/$CKAN_CONF_FILE")"
        echo "$ckan_write_datastore_configuration" > $CKAN_CONF_PATH/$CKAN_CONF_FILE
    fi
fi

## Memcached setup
if [ "$MEMCACHED_URL" != "" ]; then
    echo ""
    echo "Setting up Memcached..."
    ckan_memcached_configuration="$(sed -E "/beaker.session.key =.*/a beaker.session.type = ext:memcached" "$CKAN_CONF_PATH/$CKAN_CONF_FILE")"
    echo "$ckan_memcached_configuration" > $CKAN_CONF_PATH/$CKAN_CONF_FILE
    ckan_memcached_configuration="$(sed -E "/beaker.session.type = ext:memcached/a beaker.session.url = $MEMCACHED_URL" "$CKAN_CONF_PATH/$CKAN_CONF_FILE")"
    echo "$ckan_memcached_configuration" > $CKAN_CONF_PATH/$CKAN_CONF_FILE
else
    echo ""
    echo "No MEMCACHED configuration necessary"
fi
