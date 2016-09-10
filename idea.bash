#!/bin/bash

# bash: starts the bash shell
# else: starts IntelliJ Idea 
MODE=bashX
# set this to true to share the complete home-dir
USE_HOST_HOME_DIR=false
# set this to true to share Android
USE_HOST_ANDROID=true
# set this to true to share the Idea config
USE_HOST_IDEA_CONFIG=true
# set this to true to share the maven repository
USE_HOST_MAVEN_REPO=true

VOLUME_MOUNT_PARAMS=

if [ $MODE == 'bash' ]; then
  DETACHED_FOREGROUND='-it'
  CMD='/bin/bash'
else
  DETACHED_FOREGROUND='-d'
  CMD='/opt/intellij/bin/idea.sh'
fi

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
  addMountInHomeDir ".java/.userPrefs/jetbrains"
fi

if [ "$USE_HOST_MAVEN_REPO" = true ]; then
  addMountInHomeDir ".m2"
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
#
# when you want to run e.g. bash directly (instead of idea.sh), you must remove the -d switch and add: 
#  -t alocate a pseudo-tty
#  -i interactive: keep STDIN open iven if not attached
DOCKER_IMAGE_NAME=intellij-android
docker run \
  -v $XSOCK:$XSOCK \
  $DOCKER_ENV_VARS \
  $VOLUME_MOUNT_PARAMS  \
  $DETACHED_FOREGROUND \
  $DOCKER_IMAGE_NAME \
  $CMD




