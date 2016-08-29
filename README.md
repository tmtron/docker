# docker

builds a docker image that can start the IntelliJ IDE as the same user on the host machine

to build the images just start the `build-ALL.bash` script.

Then you can use `./idea.bash` to start the IDE

if you want to have a Launcher icon on the Desktop use
```
gnome-desktop-item-edit --create-new .
```
and select the `idea.bash` script as Command.

there are 3 docker images:
 - ubuntu-openjdk: uses a public ubuntu image and installs the open JDK
 - intellij: uses the ubuntu-openjdk image and installs the intellij IDE
 - intellij-user: create a user (and usergroup) in the container that has the same user-id (group-id) as the user that executes the script
