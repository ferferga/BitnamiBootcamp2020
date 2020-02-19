# Final Project

This folder contains the files that are part of the final project for bootcampers proposed by the Bitnami team.

The project consists in a **CKAN** installation (which I decided to make from source) and all its components, such as **Solr**, **Redis**, **memcached** and **PostgreSQL**.

## "docker-image" folder

The first part of the project consisted in making a Dockerfile + Docker-compose file (for testing the container alongside all of it's components).

Both database initialisation (with ``CKAN_INITIALIZE_DB: 'yes'``) and usage of persistence (with ``CKAN_INITIALIZE_DB: 'no'``) were tested and ran successfully.

Go inside the ``docker-image`` folder for seeing more information about the docker image that is created.

## "chart" folder

The second part of the project consisted in creating a Helm Chart for Kubernetes based in the work that was previously done with the Docker image.