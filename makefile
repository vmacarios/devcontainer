DEVCONTAINER_VERSION=0.1.0
VERSION=${DEVCONTAINER_VERSION}

IMAGENAME = devcontainer
REPO = localhost
IMAGEFULLNAME = ${REPO}/${IMAGENAME}:${VERSION}
EXPORTFILE = ${IMAGENAME}-${VERSION}.tar.gz
UPLOADDIR = "root@host:/path/container/"

# container uid mapping (Make does not provide any mathematical functions, therefore 'expr' must be used)
CONTAINER_USER_ID=2000
MAX_UID_COUNT=$$(grep $$(whoami) /etc/subuid | cut -d':' -f3)
MAX_MINUS_UID=$$(expr ${MAX_UID_COUNT} - ${CONTAINER_USER_ID})
UID_PLUS_ONE=$$(expr ${CONTAINER_USER_ID} + 1)

DOCKER = podman
DOCKERFILE = Dockerfile

.PHONY: help build push run save all

help:
	@echo "Makefile arguments:"
	@echo ""
	@echo "Makefile commands:"
	@echo "[VERSION=latest] build"
	@echo "[VERSION=latest] push"
	@echo "[VERSION=latest] run"
	@echo "[VERSION=latest] save"
	@echo "[VERSION=latest] upload"
	@echo "[VERSION=latest] all   # Runs build and push"

.DEFAULT_GOAL := all

build:
	@${DOCKER} build -f "${DOCKERFILE}" -t ${IMAGEFULLNAME} .

push:
	@${DOCKER} push ${IMAGEFULLNAME}

run:
	@${DOCKER} run \
		--rm \
		-it \
		--name ${IMAGENAME} \
		--uidmap ${CONTAINER_USER_ID}:0:1 \
		--uidmap 0:1:${CONTAINER_USER_ID} \
		--uidmap ${UID_PLUS_ONE}:${UID_PLUS_ONE}:${MAX_MINUS_UID} \
		-v "$$(pwd):/workspace" \
		-v "devcontainer-home:/user-homedir" \
		-v "ansible-galaxy:/user-homedir/.ansible/collections/ansible_collections" \
		-v "site-packages:/usr/local/lib/python3.9/site-packages" \
		${IMAGEFULLNAME} \
		bash

# create a compressed image file that can be imported with "docker load", with current version and latest
save:
	@${DOCKER} save ${IMAGEFULLNAME} ${REPO}/${IMAGENAME}:latest | gzip > ~/${EXPORTFILE} 

upload:
	@scp ~/${EXPORTFILE} ${UPLOADDIR}

all: build push

