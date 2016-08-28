#!/bin/bash
IMAGE_NAME=idea
TAG=2016.2.2
IMAGE_TAG=$IMAGE_NAME:$TAG

docker build \
  --build-arg groupId=$(id -g) \
  --build-arg groupName=$(id -gn) \
  --build-arg userId=$(id -u) \
  --build-arg userName=$USER \
  -t $IMAGE_TAG \
  intellij-user

docker tag $IMAGE_TAG $IMAGE_NAME:latest

