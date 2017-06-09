# My own Docker base image for the Rasperry Pi based on Alpine

![Alpine Linux](https://pkgs.alpinelinux.org/assets/alpinelinux-logo.svg)

# Status
[![Build Status](https://travis-ci.org/napnap75/rpi-alpine-base.svg?branch=master)](https://travis-ci.org/napnap75/rpi-alpine-base) [![Image size](https://images.microbadger.com/badges/image/napnap75/rpi-alpine-base.svg)](https://microbadger.com/images/napnap75/rpi-alpine-base "Get your own image badge on microbadger.com") [![Github link](https://assets-cdn.github.com/favicon.ico)](https://github.com/napnap75/rpi-alpine-base) [![Docker hub link](https://www.docker.com/favicon.ico)](https://hub.docker.com/r/napnap75/rpi-alpine-base/)


# Content
This image is based on [arm32v6/alpine](https://hub.docker.com/r/arm32v6/alpine/).

This image contains :

- [Alpine Linux](https://alpinelinux.org/) provided by the base image.
- [QEmu](https://github.com/multiarch/qemu-user-static) to allow the build and run of the images in x86 system (especially Travis CI)
- [Tini](https://github.com/krallin/tini) to properly manage the processes (Tini spawns a single child and wait for it to exit all the while reaping zombies and performing signal forwarding).
- [su-exec](https://github.com/ncopa/su-exec) to properly manage users permissions inside the image (see below).
- Bash because I use it in my scripts.

This image sets :

- The main and community repositories for APK (needed for su-exec).
- The CET Timezone (to have the same timestamps inside and outside the container).
- A custom script as Entrypoint to manage the users (see below).

# Usage
Use this image as the base for your own images.

To manage the user who runs the processes inside the image, you have 3 choices:

1. Do nothing, in this case the whole image is run as ROOT, its easier but not good for security reasons.
2. Set USER property in your Dockerfile (as explained in [Docker docs](https://docs.docker.com/engine/reference/builder/#user) to run the whole image with that user). However, if you share data outside the container, this does not allow to have the right ownership for this data.
3. Set the `RUN_AS` environment variable on startup (either with `docker run -e RUN_AS=1234:5678` or with the `environment` key in your compose file). In that case, the image is built with root privileges and only the main process is run as a non-priviledged user (for security reasons). The form of the `RUN_AS` variable must be `UID:GID` of the user.

If you need to do specific things in the entrypoint (for example to initialize data before running the main process), write a shell script in `/usr/sbin/docker-entrypoint-pre.sh` and it will be executed at first in the entrypoint script.

# Caveats
If you set the `RUN_AS` environment variable, the program will not be allowed to upgrade itself and you will have to manually upgrade it (either by rebuilding the image or by using the `docker exec` command (which do not use the entrypoint script and therefore is run as ROOT)).
