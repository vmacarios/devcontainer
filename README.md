# devcontainer
Encapsulated development environment to reduce the boilerplate to start developing.


## Build

> podman build -t devcontainer .


## Run

Set uid mapping, map site-packages (place where pip install the packages) to a volume (for persistency) and the current local directory to /workspace (initial directory)

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
    -v "site-packages:/usr/local/lib/python3.9/site-packages" \
    localhost/devcontainer \
    sleep infinity
```


## Forward SSH agent

To use the SSH agent inside the container, the following commands shall be executed before entering into the container

```
  exec socat $SSH_AUTH_SOCK EXEC:"podman exec -i devcontainer 'socat - UNIX-LISTEN:/home/$(podman exec devcontainer whoami)/.ssh/ssh-auth.sock,unlink-early,fork',nofork" &
  # trap "kill $!" INT TERM EXIT (only useful in script)
```

## Jump into the container

> podman exec -it devcontainer bash

## Notes
https://www.redhat.com/sysadmin/getting-started-socat