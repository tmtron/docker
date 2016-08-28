#!/bin/bash
IMAGE_NAME=intellij
TAG=2016.2.2
IMAGE_TAG=$IMAGE_NAME:$TAG

docker build \
  -t $IMAGE_TAG \
  intellij

docker tag $IMAGE_TAG $IMAGE_NAME:latest
