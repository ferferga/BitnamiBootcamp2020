# docker-image

## Overview of the folder structure

* ``scripts``: This folder contains all the helper scripts that are used in the container, based in how Bitnami's containers are packaged.
    * ``run.sh``: Starts CKAN's server
    * ``entrypoint.sh``: This script is the entrypoint of the container. It checks whether we are running the container replacing the ``run.sh`` 
    command with our own, such as ``bash``. If that's not the case, it configures the environment for CKAN.
    * ``postunpack.sh``: This script runs all the commands that need to be made with administrative privileges during the image's build time, 
    before the container is a non-root one.
    * ``setup.sh``: This script sets the configuration for CKAN based in the environment variables that are configured.

* ``Dockerfile``: This dockerfile builds the image of the CKAN container.
* ``docker-compose.yaml``: This docker-compose project configures CKAN in the first boot.
* ``docker-compose-persistent.yaml``: This docker-compose project it's exactly the same ``docker-compose.yaml``, but with ``CKAN_INITIALIZE_DB`` set to no, for using an already existing database. **Run after ``docker-compose.yaml`` or it will not work**.
*Remember to rename this file to ``docker-compose.yaml``*.

docker-compose files can be run ``cd``' ing to the directory where they are located and running ``docker-compose up``.

Stop the docker-compose project by running ``docker-compose down`` in the same folder of your ``docker-compose.yaml``.
For removing the created networks and volumes, use ``docker-compose down -v``

## Environment variables

| Variable | Default | Description |
|----------|---------|-------------|
| ``CKAN_HOST`` | ``127.0.0.1`` | Sets the address where CKAN will be served |
| ``CKAN_PORT`` | ``5000`` | Sets the port where CKAN will serve the content|
| ``CKAN_INITIALIZE_DB`` | ``no`` | Starts CKAN from scratch and creates a database |
| ``CKAN_SITE_ID`` | ``default`` | Sets CKAN's site id |
| ``CKAN_PLUGINS`` | ``stats text_view image_view recline_view datastore`` | Sets CKAN's plugins |
| ``CKAN_STORAGE_PATH`` | ``/data/storage`` | Sets CKAN's storage path |
| ``CKAN_CONF_PATH`` | ``/data/config`` | Sets CKAN's config file |
| ``CKAN_CONF_FILE`` | ``development.ini`` | Sets CKAN's main config file |
| ``CKAN_ADMIN`` | ``admin`` | Sets the admin user that will be created on setup |
| ``CKAN_ADMIN_EMAIL`` | ``user@example.com`` | Sets CKAN's admin's email |
| ``CKAN_ADMIN_PASSWORD`` | ``bitnamiadmin`` | Sets CKAN's admin password |
| ``POSTGRESQL_HOST`` | ``postgres`` | Sets PostgreSQL host |
| ``POSTGRESQL_PORT`` | ``5432`` | Sets PostgreSQL port |
| ``POSTGRESQL_DATABASE_USER`` | ``ckan_default`` | Sets the database user that will be used by CKAN |
| ``POSTGRESQL_DATABASE_USER_PASSWORD`` | ``ckan_default`` | Sets the password of the database user that will be used by CKAN |
| ``POSTGRESQL_DATASTORE_USER_PASSWORD`` | ``ckan_default`` | Sets the password of the database user that will be used by CKAN's datastore |
| ``POSTGRESQL_DATASTORE_USER`` | ``ckan_datastore`` | Sets the user that will be used by CKAN's datastore |
| ``POSTGRESQL_CKAN_DATABASE`` | ``ckan_default`` | Sets the name of CKAN's database |
| ``POSTGRESQL_CKAN_DATASTORE`` | ``ckan_datastore`` | Sets the name of CKAN's datastore database |
| ``POSTGRESQL_ROOT_USER`` | ``postgres`` | Specifies the user with administrative privileges in PostgreSQL |
| ``POSTGRESQL_ROOT_PASSWORD`` | ``root`` | Specifies the password of the user with administrative privileges in PostgreSQL |
| ``SOLR_URL`` | ``solr:8983`` | Sets the url (host:port) of Solr server |
| ``SOLR_CORE_NAME`` | ``solr`` | Sets the name of Solr's core |
| ``REDIS_URL`` | ``redis:6379`` | Sets the url (host:port) of the Redis server |
| ``REDIS_USER`` | ``redis`` | Sets the user that will be used to connect to the redis server |
| ``REDIS_PASSWORD`` | *None* | Sets the password that will be used to connect to the redis server | 
| ``MEMCACHED_URL`` | *None* | Sets the URL (host:port) of memcached server |