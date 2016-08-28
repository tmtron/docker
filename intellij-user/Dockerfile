FROM intellij

MAINTAINER martin@tmtron.com

ARG groupId
ARG groupName
ARG userId
ARG userName

# using host env vars in the Docker script does not WORKDIR
# workaround is to use build arguments:
# * https://docs.docker.com/engine/reference/builder/#/arg
# * http://stackoverflow.com/a/34545644/6287240

# create a group and user in the container 
RUN groupadd --gid $groupId $groupName \
  && useradd --shell /bin/bash --create-home --gid $groupId --uid $userId $userName

# switch to that user and workdir
USER $userName
WORKDIR /home/$userName/

