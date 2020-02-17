## Introduction

We have created our own docker image with 4 helper scripts:

```
postunpack.sh
entrypoint.sh
setup.sh
run.sh
```

``postunpack.sh`` Runs a first setup process global for all users

``entrypoint.sh`` is the script that instantiates the container

``setup.sh`` configure additional steps in the container based in user input, such as the ``NGINX_PORT`` variable.

``run.sh`` is called by the entrypoint to start the nginx process.

## How to

1. Download all the files from this folder and place it in a folder where you have permissions in your system.
2. ``cd`` to that directory.
3. Run ``docker-compose up``. Your website will be up and running in a minute, so enjoy!

Run ``docker-compose down -V`` to kill the container and remove the associated data.
