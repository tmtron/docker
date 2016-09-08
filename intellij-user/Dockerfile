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

# install sudo
# install git version control
RUN apt-get update \
  && apt-get -y install sudo \
  && apt-get -y install git 
# no need to install maven: it is bundled in Idea
#  && apt-get -y install maven

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

