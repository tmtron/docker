#!/bin/bash
IMAGE_NAME=intellij
TAG=2016.2.3
IMAGE_TAG=$IMAGE_NAME:$TAG

docker build \
  -t $IMAGE_TAG \
  --build-arg INTELLIJ_VERSION=$TAG \
  intellij

docker tag $IMAGE_TAG $IMAGE_NAME:latest
