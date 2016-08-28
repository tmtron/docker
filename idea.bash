#!/bin/bash

# allow the docker container to show X11 windows
xhost +local:
# used to mount the X11 socket of the host to the container
export XSOCK=/tmp/.X11-unix/X0

docker run \
  -v $XSOCK:$XSOCK \
  -v /home/$USER:/home/$USER \
  -e DISPLAY \
  -it \
  idea \
  /opt/intellij/bin/idea.sh

