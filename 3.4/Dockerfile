FROM hypriot/rpi-alpine:3.4

# Install dependencies and set timezone
RUN echo -e "http://fr.alpinelinux.org/alpine/v3.4/main\nhttp://fr.alpinelinux.org/alpine/v3.4/community" > /etc/apk/repositories \
	&& apk update \
	&& apk upgrade \
	&& apk add bash tini su-exec alpine-conf tzdata \
	&& setup-timezone -z CET \
	&& apk del alpine-conf tzdata \
	&& rm -rf /var/cache/apk/*

# Add my own entry script to run as one user
ADD docker-entrypoint.sh /usr/sbin/docker-entrypoint.sh
RUN chmod +x /usr/sbin/docker-entrypoint.sh

# Set Tini as entrypoint 
ENTRYPOINT ["/sbin/tini", "--", "/usr/sbin/docker-entrypoint.sh"]
