FROM hypriot/rpi-alpine-scratch:edge

# Add qemu to allow build of this image in Travis CI
ADD qemu-arm-static /usr/bin
ADD binfmt_misc-register /proc/sys/fs/binfmt_misc/register
ENV ARCH=arm

# Install dependencies
RUN echo -e "http://fr.alpinelinux.org/alpine/latest-stable/main\nhttp://fr.alpinelinux.org/alpine/latest-stable/community" > /etc/apk/repositories \
  && apk update \
  && apk upgrade \
  && apk add bash tini su-exec

# Set timezone
RUN setup-timezone -z CET

# Add my own entry script to run as one user
ADD entry.sh /usr/sbin/entry.sh
RUN chmod +x /usr/sbin/entry.sh

# Set Tini as entrypoint 
ENTRYPOINT ["/sbin/tini", "--", "/usr/sbin/entry.sh"]
 
