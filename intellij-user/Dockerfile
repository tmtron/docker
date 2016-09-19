FROM intellij

MAINTAINER martin@tmtron.com

# using host env vars in the Docker script does not work
# workaround is to use build arguments:
# * https://docs.docker.com/engine/reference/builder/#/arg
# * http://stackoverflow.com/a/34545644/6287240

ARG groupId
ARG groupName
ARG userId
ARG userName
ARG ANDROID_SDK_VERSION=24.4.1
ARG ANDROID_SDK_URL=https://dl.google.com/android/android-sdk_r${ANDROID_SDK_VERSION}-linux.tgz

# install sudo
# install git version control
# install maven
#   note: maven is bundled in Idea, but we want the newest version
# install gnupg2
#   this is needed to sign maven artifacts before uploading to maven central 
RUN apt-get update \
  && apt-get -y install sudo \
  && apt-get -y install git \
  && apt-get -y install git-flow \
  && apt-get -y install maven \
  && apt-get -y install gnupg2

ENV M2_HOME=/usr/share/maven
ENV M2=$M2_HOME/bin
#ENV PATH=$M2:$PATH

# * create a group in the container
# * create the user in the container
# * add the user to sudo in the container 
# * allow the user to execute all commands with admin rights
RUN groupadd --gid $groupId $groupName \
  && useradd --shell /bin/bash --create-home --gid $groupId --uid $userId $userName \
  && adduser $userName sudo \
  && echo "$userName ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers 

# switch to that user and workdir
USER $userName
WORKDIR /home/$userName/

# install android SDK
RUN wget --progress=bar:force $ANDROID_SDK_URL \
  && tar -xzf android-sdk_r${ANDROID_SDK_VERSION}-linux.tgz \
  && rm android-sdk_r${ANDROID_SDK_VERSION}-linux.tgz 

ENV ANDROID_HOME=/home/$userName/android-sdk-linux 

