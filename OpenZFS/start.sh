#!/bin/bash
set -x
NAME=zfs-builder

podman build -t $NAME .
podman run --name $NAME --user 3005:3005 --security-opt no-new-privileges --cap-drop ALL --network none -d $NAME
podman cp $NAME:/install/rpms.zip $HOME/Downloads/
podman stop $NAME
podman rm $NAME -f
podman image rm $NAME -f