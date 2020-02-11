### Exercise 1
**Find the way to override the entrypoint of an existing image**

By running ``docker run --entrypoint <entrypoint.sh> <our_image>`` we will override the container's entrypoint with our own.

``entrypoint.sh`` is for reference only, we can give any name to our entrypoint script.

### Exercise 2
**Find the way to change the user that will run the container**

By running ``docker run --user <user_to_use> <our_image>`` we can tell Docker which user we want to use in the container.

Following examples are valid:
``(-u or --user)=[ username | username:group | uid | uid:gid | username:gid | uid:group ]``

### Exercise 3
**Find the way to build an image in a given context, but using a Dockerfile from a different location**

We must pass ``--file`` or ``-f`` arguments to the ``docker build`` command,
followed with an absolute or relative path to the Dockerfile.

### Exercise 4
**Find the way to ignore the cached layers when building an image**

We must pass ``--no-cache`` arguments to the ``docker build`` command.

### Exercise 5
**Find the way to define in a docker-compose.yml that an image must be built**

The ``build: .`` directive in ``docker-compose.yaml`` will build the ``Dockerfile`` located in the same directory of the ``yaml``.
We can specify any Dockerfile by its absolute or relative path there without any problem.

