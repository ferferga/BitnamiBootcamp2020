* We have created our own docker image with 4 helper scripts:

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

There is also a docker-compose.yaml to orchestrate the build and runtime of the container in a single command.