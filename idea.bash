#!/bin/bash

# check command line argument
# "bash": starts the bash shell
# else: starts IntelliJ Idea
if [ "${1}" == "bash" ]; then
  # when you want to run e.g. bash directly (instead of idea.sh), you must not use the -d switch and add: 
  #  -t alocate a pseudo-tty
  #  -i interactive: keep STDIN open even if not attached
  DETACHED_FOREGROUND='-it'
  CMD='/bin/bash'
else
  DETACHED_FOREGROUND='-d'
  CMD='/opt/intellij/bin/idea.sh'
fi 

# set this to true to share the complete home-dir
USE_HOST_HOME_DIR=false
# set this to true to share Android
USE_HOST_ANDROID=true
# set this to true to share the Idea config
USE_HOST_IDEA_CONFIG=true
# set this to true to share the maven repository
USE_HOST_MAVEN_REPO=true
# set this to true to share the GIT config
USE_HOST_GIT_CONFIG=true
# set this to true to share the gnupg info 
USE_HOST_GNUPG_CONFIG=true

VOLUME_MOUNT_PARAMS=

addMountDir () {
  if [ -z "${1// }" ]; then
    echo addMountDir: parameter is required!
    exit 1
  fi  
  if [ -z "${2// }" ]; then
    CONTAINER_DIR=$1
  else
    CONTAINER_DIR=$2
  fi  
  VOLUME_MOUNT_PARAMS="$VOLUME_MOUNT_PARAMS -v $1:$CONTAINER_DIR"
}

# will append a volume mount direction to the VOLUME_MOUNT_PARAMS variable
# arguments
# 1: the directory to mount - relative to the users home directory
#
# example call:
#   addMountInHomeDir "IdeaProjects"
#   e.g. when the current user is "tmtron"
#   will append: -v /home/tmtron/IdeaProjects:/home/tmtron/IdeaProjects 
addMountInHomeDir () {
  if [ -z "${1// }" ]; then
    echo addMountInHomeDir: parameter is required!
    exit 1
  fi  
  addMountDir "/home/$USER/$1"
}

# maybe also mount these dirs?
#.gitconfig
# .local/share: 
#  JetBrains, 
#   keyrings
# .p2 --> eclipse? 

DOCKER_ENV_VARS=
if [ "$USE_HOST_ANDROID" = true ]; then
  addMountInHomeDir ".android"
  addMountInHomeDir "android-sdk-linux"
fi

if [ "$USE_HOST_IDEA_CONFIG" = true ]; then  
  # try to find the hidden Idea directory for the settings in the users
  # home directory
  # the directory name may be e.g. ".IdeaIC2016.2"
  IdeaHiddenDir=$(ls ~ -a | grep .IdeaIC)
  if [ -z "${IdeaHiddenDir// }" ]; then
    echo "no hidden .IdeaIC directory found in user home!"
    exit 1  
  fi
  addMountInHomeDir "$IdeaHiddenDir"
  addMountInHomeDir "IdeaProjects"
  # otherwise the IDE will always ask to accept the Terms and Conditions
  # note: Idea will create some hidden lock files in this directory
  #       and also store/update the prefs.xml file
  addMountInHomeDir ".java/.userPrefs/"
fi

if [ "$USE_HOST_MAVEN_REPO" = true ]; then
  addMountInHomeDir ".m2"
fi

if [ "$USE_HOST_GIT_CONFIG" = true ]; then
  addMountInHomeDir ".gitconfig"
fi

if [ "$USE_HOST_GNUPG_CONFIG" = true ]; then
  addMountInHomeDir ".gnupg"
fi

if [ "$USE_HOST_HOME_DIR" = true ]; then
  echo sharing full home-directory  
  addMountDir "/home/$USER"
fi

# if no mounts have been set, we mount the complete home-directory
# see http://unix.stackexchange.com/a/146945
if [ -z "${VOLUME_MOUNT_PARAMS// }" ]; then
  echo no directories shared  
fi

#echo $VOLUME_MOUNT_PARAMS && exit

# allow the docker container to show X11 windows
xhost +local:
# used to mount the X11 socket of the host to the container
export XSOCK=/tmp/.X11-unix/X0

DOCKER_ENV_VARS="-e DISPLAY $DOCKER_ENV_VARS"

# docker run \
#   -v $XSOCK:$XSOCK \
#   -v /home/$USER:/home/$USER \
#   -e DISPLAY \
#   -d \
#   idea \
#   /opt/intellij/bin/idea.sh
#
# -d detach: runs the container in the background and prints out the container id
# -p publish a port: we publish port 8080 so that we can access a web-server running
#                    in the container from the host: i.e. open a browser on the host 
#                    and navigate to http://localhost:8080/  
DOCKER_IMAGE_NAME=intellij-user
docker run \
  -v $XSOCK:$XSOCK \
  -p 8080:8080 \
  $DOCKER_ENV_VARS \
  $VOLUME_MOUNT_PARAMS  \
  $DETACHED_FOREGROUND \
  $DOCKER_IMAGE_NAME \
  $CMD

