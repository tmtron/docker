#!/bin/bash

# allow the docker container to show X11 windows
xhost +local:
# used to mount the X11 socket of the host to the container
export XSOCK=/tmp/.X11-unix/X0

docker run \
  -v $XSOCK:$XSOCK \
  -v /home/$USER:/home/$USER \
  -e DISPLAY \
  -e ANDROID_HOME \
  -d \
  idea \
  /opt/intellij/bin/idea.sh

# ANDROID_HOME is required because we may need it for android development/testing

# -d detach: runs the container in the background and prints out the container id

# when you want to run e.g. bash directly (instead of idea.sh), you must remove the -d switch and add: 
#  -t alocate a pseudo-tty
#  -i interactive: keep STDIN open iven if not attached




