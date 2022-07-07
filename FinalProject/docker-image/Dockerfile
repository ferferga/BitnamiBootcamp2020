FROM bitnami/python:2.7.17 AS ckan
WORKDIR /
RUN pip install -e 'git+https://github.com/ckan/ckan.git@ckan-2.8.2#egg=ckan' \
    && pip install -r /src/ckan/requirements.txt
COPY scripts /scripts
RUN chmod +x -R /scripts
ENV CKAN_HOST="127.0.0.1" \
    CKAN_PORT="5000" \
    CKAN_INITIALIZE_DB="no" \
    CKAN_SITE_ID="default" \
    CKAN_PLUGINS="stats text_view image_view recline_view datastore" \
    CKAN_STORAGE_PATH="/data/storage" \
    CKAN_CONF_PATH="/data/config" \
    CKAN_CONF_FILE="development.ini" \
    CKAN_ADMIN="admin" \
    CKAN_ADMIN_EMAIL="user@example.com" \
    CKAN_ADMIN_PASSWORD="bitnamiadmin" \
    POSTGRESQL_HOST="postgres" \
    POSTGRESQL_PORT="5432" \
    POSTGRESQL_DATABASE_USER="ckan_default" \
    POSTGRESQL_DATABASE_USER_PASSWORD="ckan_default" \
    POSTGRESQL_DATASTORE_USER_PASSWORD="ckan_default" \
    POSTGRESQL_DATASTORE_USER="ckan_datastore" \
    POSTGRESQL_CKAN_DATABASE="ckan_default" \
    POSTGRESQL_CKAN_DATASTORE="ckan_datastore" \
    POSTGRESQL_ROOT_USER="postgres" \
    POSTGRESQL_ROOT_PASSWORD="root" \
    SOLR_URL="solr:8983" \
    SOLR_CORE_NAME="solr" \
    REDIS_URL="redis:6379" \
    REDIS_USER="redis" \
    REDIS_PASSWORD="" \
    MEMCACHED_URL=""
RUN install_packages postgresql-client supervisor libmagic-dev libmemcached-dev zlib1g-dev && pip install pylibmc && \
    apt remove --purge --auto-remove -y zlib1g-dev git*
RUN /scripts/postunpack.sh
WORKDIR ${CKAN_STORAGE_PATH}
USER ckan
ENTRYPOINT [ "/scripts/entrypoint.sh" ]
CMD [ "/scripts/run.sh" ]