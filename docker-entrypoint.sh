#!/bin/bash

# Run a custom script (if provided) before running the command
if [ -f /usr/sbin/docker-entrypoint-pre.sh ]; then
  /usr/sbin/docker-entrypoint-pre.sh $*
fi

# Run the command as a local user with a UID and GID given as parameters
if [ "${RUN_AS}" ]; then
  RUN_AS_UID=$(echo $RUN_AS | cut -d: -f1)
  RUN_AS_GID=$(echo $RUN_AS | cut -d: -f2)
  if [ $(id -u dummy_user 2>/dev/null || echo -1) -le 0 ]; then
    addgroup -g $RUN_AS_GID dummy_group
    adduser -D -u $RUN_AS_UID -G dummy_group -h $HOME dummy_user
  elif [ $(id -u dummy_user) -ne $RUN_AS_UID ]; then
    deluser dummy_user
    delgroup dummy_group
    addgroup -g $RUN_AS_GID dummy_group
    adduser -D -u $RUN_AS_UID -G dummy_group -h $HOME dummy_user
  fi
  if [ -d $HOME ]; then
    chown -R dummy_user:dummy_group $HOME
  fi
  su-exec dummy_user $*
else
  $*
fi
