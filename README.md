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
    -it \
    --name devcontainer \
    --uidmap $container_user_id:0:1 \
    --uidmap 0:1:$container_user_id \
    --uidmap $uid_plus_one:$uid_plus_one:$max_minus_uid \
    -v "$(pwd):/workspace" \
    -v "site-packages:/usr/local/lib/python3.9/site-packages" \
    localhost/devcontainer \
    bash
```