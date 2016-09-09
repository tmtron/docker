FROM ubuntu:16.04

MAINTAINER martin@tmtron.com

# install add-apt-repository
# Configure the openjdk repository
RUN apt-get update \ 
	&& apt-get install -y software-properties-common \
	&& add-apt-repository ppa:openjdk-r/ppa
# apt-get install 
#   -y automatically accept the question with "yes"

# Install OpenJDK 8
RUN add-apt-repository ppa:webupd8team/java && apt-get update \
	&& apt-get install -y \ 
		libxext-dev libxrender-dev libxtst-dev \
		openjdk-8-jdk \
		wget \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /tmp/*

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64	
