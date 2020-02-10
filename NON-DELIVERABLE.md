### Exercise 1
**Find a way to run a docker container that auto-restarts on failure**

For running a docker container that auto restarts on failure, we must append a ``--restart on-failure``
argument to the ``docker run`` command. This means that a restart will be triggered whenever the container exists with a non-zero exit code.

### Exercise 2
**Find a way to launch a container that auto-deletes itself when finished**

We need to append the ``--rm`` argument to the ``docker run`` command.

### Exercise 3
**Find the way to set the number of CPUs a container can use**

We need to append the ``--cpuset-cpus`` argument to the ``docker run`` command:

It works using ranges or indivual values. For example, if we want to only allow the usage of CPU Cores 0 and 3, we would append ``--cpuset-cpus 0,3``.
However, we can also specify ranges, (like cores from 0 to 6): ``--cpuset-cpus 0-6``

### Exercise 4
**Find the way to create a privileged container. Try finding an operation that can be done using a privileged container and not a regular container**

We need to append the ``--privileged`` flag to the ``docker create`` or ``docker run`` command.

Priviliged containers have full access to resources in the host system, which is useful for accessing some stuff only available to the host OS like devices (those under the ``/dev`` directory), 
so processes running inside the docker container has the same level of access that processes running outside. Some applications, like ``ffmpeg`` might not run perfectly in docker containers that are unprivileged due to this, as access to the GPU decoding capabilities are restricted in containers.

Running privileges containers is a really unsafe practice, as it can access files in your own system, so you might end up deleting or modifying something from your host environment.

One workaround for having host devices available in a docker container is the use of the ``--device`` flag in the ``docker run`` command.

### Exercise 5
**Using docker ps, docker inspect and a bit of scripting to create a script that shows the container names together with its internal IP**

```docker ps -q
#!/bin/bash
docker inspect -f '{{.Name}}: {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -q)
```

### Exercise 6
**Create a new image based on minideb that has the application *kong*. Use docker commit (we will see a different way next session)**

First, we go inside the [Kong's documentation](https://docs.konghq.com/install/debian/) to get some information about the repositories. Then, we run ``docker run -it bitnami/minideb bash`` and configure all the repositories inside the environment.

Here is an overview of the commands we will be using. First, we check that we're root inside the container with the ``whoami`` command. Then, we run the following:

```
apt-get update

apt-get install -y apt-transport-https curl gnupg

echo "deb https://kong.bintray.com/kong-deb buster main" | tee -a /etc/apt/sources.list

curl -o bintray.key https://bintray.com/user/downloadSubjectPublicKey?username=bintray

apt-key add bintray.key && rm -rf bintray.key

apt-get update

apt-get install -y kong
```
Just after doing that, we must check the name of our running container using ``docker ps``. Once the name of the container is known to us, we can issue the ``commit`` command that will generate an image:

``docker commit --author "Fernando - ferferga. Bitnami Bootcamp 2020" --message "First release" __container_id__ ferferga/kong:1.0``

### Exercise 7
**Create an account in Docker Hub and find the way to push an image (use the one in Exercise 6 for example)**

Before starting, we need to login into docker ``docker login --username=ferferga``.

Then, we run ``docker push ferferga/kong``.

My image is live at [Docker Hub](https://hub.docker.com/repository/docker/ferferga/kong)

### Exercise 8
**Find the way to “rename” an existing image (without docker commit)**

Using the ``docker tag`` command we can create a new tag for the image. Afterwards, we can remove the old one, doing the equivalent of renaming:

```
docker tag <old_name> <new_name>
docker rmi <old_name>
```