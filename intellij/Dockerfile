FROM ubuntu-oraclejdk

MAINTAINER martin@tmtron.com

ARG INTELLIJ_VERSION
ARG INTELLIJ_URL=https://download-cf.jetbrains.com/idea/ideaIC-${INTELLIJ_VERSION}.tar.gz

# install wget
# download intellij archive
# extract intellij to /opt/intellij
RUN apt-get update \
 && apt-get install -y wget \
 && wget --progress=bar:force $INTELLIJ_URL -O /tmp/intellij.tar.gz \
 && mkdir /opt/intellij \
 && tar -xzf /tmp/intellij.tar.gz -C /opt/intellij --strip-components=1 \
 && rm -rf /tmp/* 
# wget paratmers
#   -O output file
# tar parameters
#   -x extract
#   -z also apply gzip
#   -f archive file
#   -C change to this directory


