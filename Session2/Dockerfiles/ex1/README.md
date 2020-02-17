## ARG

This instruction defines variables that will get used during the build process. It has the distinctive feature that it's the only instruction
that may precede a ``FROM`` instruction in a ``Dockerfile``.

This is useful for simplifying version control, such as follows:

```
ARG IMAGE_VERSION = 10
FROM bitnami/minideb:$IMAGE_VERSION
```

## ONBUILD

This instruction is followed by another instruction. Like this:

```
ONBUILD RUN apt update
ONBUILD ADD ./run.sh
```

This instruction runs another instruction when the image that was built in the context where the ``ONBUILD`` is located is a base for
another image build in a multi-stage build.

This instruction could be useful for multi-stage builds, where we can set some configuration done in a child image and we want
to apply it to the parent image as well.

## STOPSIGNAL

This instruction defines the exit signal that will be sent to the container running this image to exit.

This instruction could be useful for helping us in the process of debugging issues with containers,
as we set a custom (but known and expected to us) signal that we can handle in an specific scenario.

## HEALTHCHECK

This instruction tells to Docker how it should perform tests to an image. Normally is used alongside the ``CMD`` instruction for running the script that will perform the tests inside the container. Take a look at this example:

``HEALTHCHECK CMD command``

We can also disable any healthcheck inherited
from the parent image (the one specified in ``FROM``) as, by default, parent's healthchecks
will be performed.

``HEALTHCHECK NONE``

We can pass some options to the ``HEALTCHECK`` instruction, just before between ``HEALTHCHECK`` and ``CMD`` commands. 
Here is an overview of the available options:

```
--interval (Time to wait before running the tests after a failure. Default: 30s)
--timeout (Maximum time that the tests can take. After this time, tests will be considered unsuccessful. Default: 30s)
--start-period (Time before running the tests. Default: 0s)
--retries=N (Number of retries that will be performed if tests fail.Default: 3)
```

This instruction is necessary and helpful for a good Continuos Integration and an overall overview of our container's status.

## SHELL

This instruction allows us to change the shell used. In Linux and Mac, the default one is ``sh`` (which we can override with ``bash`` if we're running special instructions not available in ``sh``, for example).

This instruction, although not that necessary in UNIX environments, it's mostly essentials in Windows containers, as there are two shells: ``cmd`` and ``powershell``.
