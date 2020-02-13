[I'm using a proxy based in NodeJS](https://github.com/shroomlife/docker-https-proxy), 
which handles each domain based in the container's name. Let's see it in an example:

``container_name: mytestsite.com.proxy``

First, the proxy checks for containers' hostnames ending with ``.proxy`` using Docker's name resolution. Then, it considers that everything that is in the container's name before ``.proxy`` is the hostname it needs to listen to. All HTTP and HTTPS requests made using that URL will be redirected to the correspoding ports 80 and 443 of the container.

I choose this method over [the one stated in Docker's docs](https://docs.docker.com/network/proxy/)
because it's more compatible across all versions of Docker and doesn't require any configuration
in the users' end.

## Instructions for using

1. Download this docker-compose and place it a directory where you have permissions, anywhere in your system. ``cd`` to that directory.

2. Run ``nano /etc/hosts`` and add the following lines at the top of the file:

```
127.0.0.1   myfirstwp.net
127.0.0.1   myjoomla.net
```

3. Start the docker-compose project by running ``docker-compose up``.

4. Once the containers are initialized, fire a browser and try accessing ``myfirstwp.net`` and ``myjoomla.net``. Enjoy!