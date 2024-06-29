# devcontainer
Encapsulated development environment to reduce the boilerplate to start developing.


## Build
> podman build -t devcontainer .


## Run
Map site-packages (place where pip install the packages) to a volume (for persistency) and the current local directory to /workspace (initial directory)

> podman run --rm -it --name devcontainer -v "$(pwd):/workspace" -v "site-packages:/usr/local/lib/python3.9/site-packages" localhost/devcontainer bash