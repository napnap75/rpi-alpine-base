FROM hypriot/rpi-alpine-scratch:v3.4

# Install dependencies
RUN echo -e "http://fr.alpinelinux.org/alpine/v3.4/main\nhttp://fr.alpinelinux.org/alpine/v3.4/community" > /etc/apk/repositories \
	&& apk update \
	&& apk upgrade \
	&& apk add bash tini su-exec \
	&& rm -rf /var/cache/apk/*

# Set timezone
RUN setup-timezone -z CET

# Add my own entry script to run as one user
ADD docker-entrypoint.sh /usr/sbin/docker-entrypoint.sh
RUN chmod +x /usr/sbin/docker-entrypoint.sh

# Set Tini as entrypoint 
ENTRYPOINT ["/sbin/tini", "--", "/usr/sbin/docker-entrypoint.sh"]
 
