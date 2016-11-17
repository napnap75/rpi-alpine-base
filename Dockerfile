#FROM hypriot/rpi-alpine-scratch
FROM multiarch/alpine:armhf-v3.3

# Install dependencies
RUN echo -e "http://fr.alpinelinux.org/alpine/v3.3/main\nhttp://fr.alpinelinux.org/alpine/v3.3/community" > /etc/apk/repositories \
  && apk update \
  && apk upgrade \
  && apk add bash tini su-exec

# Set timezone
RUN setup-timezone -z CET

# Add my own entry script to run as one user
ADD entry.sh /sbin/entry.sh
RUN chmod +x /sbin/entry.sh

# Set Tini as entrypoint 
ENTRYPOINT ["/sbin/tini", "--", "/sbin/entry.sh"]
