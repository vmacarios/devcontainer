# devcontainer
Encapsulated development environment to reduce the boilerplate to start developing.


To build use:
podman build -t devcontainer .

To run use:
You will be then inside the container with the site-packages (place where pip install the packages) mapped to a volume (for persistency) 
and the local directory mapped to /workspace (initial directory)
podman run --rm -it --name devcontainer -v "$(pwd):/workspace" -v "site-packages:/usr/local/lib/python3.9/site-packages" localhost/devcontainer bash