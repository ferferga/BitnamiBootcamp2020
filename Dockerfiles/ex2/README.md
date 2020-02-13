## How To

1. Download the Dockerfile to a file where you have permissions.
2. ``cd`` to the directory where you downloaded the Dockerfile.
3. Run ``docker build . -t <name_you_want_for_your_image>``

Alternatively, you can also run ``docker-compose up`` to start the container. Running ``docker-compose down -v`` will delete all the data generated suring the runtime of the containers.

## Notes

* You can run the ``docker image prune`` command to remove the intermediate ``downloader``, ``builder`` and ``generator`` images.
Do this while running a container using the image you just generated, as it will be removed as well if you don't do that.
* I tried running from scratch, but hugo depends still in some ``bash`` builtins like ``cd`` to work.
