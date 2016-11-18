FROM hypriot/rpi-alpine-scratch

# Add qemu to allow build of this image in Travis CI
ADD https://github.com/multiarch/qemu-user-static/releases/download/v2.6.0/x86_64_qemu-arm-static.tar.gz /usr/bin
ADD binfmt_misc-register /proc/sys/fs/binfmt_misc/register

# Install dependencies
RUN echo -e "http://fr.alpinelinux.org/alpine/latest-stable/main\nhttp://fr.alpinelinux.org/alpine/latest-stable/community" > /etc/apk/repositories \
  && apk update \
  && apk upgrade \
  && apk add bash tini su-exec qemu

# Set timezone
RUN setup-timezone -z CET

# Add my own entry script to run as one user
ADD entry.sh /sbin/entry.sh
RUN chmod +x /sbin/entry.sh

# Set Tini as entrypoint 
ENTRYPOINT ["/sbin/tini", "--", "/sbin/entry.sh"]
