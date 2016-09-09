#!/bin/bash
IMAGE_NAME=intellij-android
ANDROID_SDK_VERSION=24.4.1 
TAG=$ANDROID_SDK_VERSION
IMAGE_TAG=$IMAGE_NAME:$TAG

docker build \
  --build-arg groupId=$(id -g) \
  --build-arg groupName=$(id -gn) \
  --build-arg userId=$(id -u) \
  --build-arg userName=$USER \
  --build-arg ANDROID_SDK_VERSION=$ANDROID_SDK_VERSION \
  -t $IMAGE_TAG \
  intellij-user

docker tag $IMAGE_TAG $IMAGE_NAME:latest

