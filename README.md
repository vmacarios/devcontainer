# devcontainer
Encapsulated development environment to reduce the boilerplate to start developing.


## Build

> podman build -t devcontainer .


## Run

As the username can be changed in the Dockerfile, a symlink to the user home directory is 
created at the root directory (/user-homedir)  
The following command set uid mapping, map the user-homedir, ansible-galaxy and site-packages 
(place where pip install the packages) to a volume (for persistency), and the current local directory 
to /workspace (initial directory) and start the container in background

```
container_user_id=2000
max_uid_count=$(grep $(whoami) /etc/subuid | cut -d':' -f3)
max_minus_uid=$((max_uid_count - container_user_id))
uid_plus_one=$((container_user_id + 1))

podman run \
    --rm \
    -d \
    --name devcontainer \
    --uidmap $container_user_id:0:1 \
    --uidmap 0:1:$container_user_id \
    --uidmap $uid_plus_one:$uid_plus_one:$max_minus_uid \
    -v "$(pwd):/workspace" \
    -v "devcontainer-home:/user-homedir" \
    -v "site-packages:/usr/local/lib/python3.13/site-packages" \
    -v "ansible-galaxy:/user-homedir/.ansible/collections/ansible_collections" \
    -v "$SSH_AUTH_SOCK:/user-homedir/.ssh/ssh-auth.sock" \
    localhost/devcontainer
```


## Jump into the container

> podman exec -it devcontainer bash


## SSH agent forwarding

The SSH agent is forwarded into the container by mapping the $SSH_AUTH_SOCK socket
