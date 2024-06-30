FROM python:3.9.19-slim as base


FROM base
RUN apt-get update && \
    apt-get install --no-install-recommends -y \   
        ansible-core \
        libgl1 \
        libglib2.0-0 \
        libgomp1 \
        vim-tiny \
        # libx11-6 \
        # libxcb1 \
        # libxau6 \
        # libxdmcp6 \
        # libbsd0 \
        # libsm6 \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -ms /bin/bash -u 2000 service

USER service
ENV HOME=/home/service \
    TERM=xterm-256color
COPY bashrc $HOME/.bashrc


WORKDIR /workspace
