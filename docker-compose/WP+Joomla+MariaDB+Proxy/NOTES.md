[I'm using a proxy based in NodeJS](https://github.com/shroomlife/docker-https-proxy), 
which handles each domain based in the container's name. Let's see it in an example:

``container_name: mytestsite.com.proxy``

First, the proxy checks for containers' hostnames ending with ``.proxy`` using Docker's name resolution. Then, it considers that everything that is in the container's name before ``.proxy`` is the hostname it needs to listen to. All HTTP and HTTPS requests made using that URL will be redirected to the correspoding ports 80 and 443 of the container.

I choose this method over [the one stated in Docker's docs](https://docs.docker.com/network/proxy/)
because it's more compatible across all versions of Docker and doesn't require any configuratin
in the users' end.