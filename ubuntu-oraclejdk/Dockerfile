FROM ubuntu:16.04

MAINTAINER martin@tmtron.com

# see https://github.com/dockerfile/java/blob/master/oracle-java8/Dockerfile

# install add-apt-repository
# Configure the openjdk repository
RUN apt-get update \ 
	&& apt-get install -y software-properties-common \
	&& add-apt-repository ppa:webupd8team/java

# apt-get install libxrender1 libxtst6 libxi6
#   otherwise Intellij Idea will not start
#   see: http://askubuntu.com/a/826946/538840
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  apt-get install -y libxrender1 libxtst6 libxi6 && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle  
