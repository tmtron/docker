#!/bin/bash
IMAGE_NAME=ubuntu-openjdk
TAG=16.04-8
IMAGE_TAG=$IMAGE_NAME:$TAG

docker build \
  -t $IMAGE_TAG \
  ubuntu-openjdk

docker tag $IMAGE_TAG $IMAGE_NAME:latest
