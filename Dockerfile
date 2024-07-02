FROM python:3.9.19-slim as base


FROM base
ARG USERNAME=service
ARG UID=2000
COPY bash.bashrc /tmp/bash.bashrc
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        ansible-core \
        libgl1 \
        libglib2.0-0 \
        libgomp1 \
        socat \
        vim-tiny \
        # libx11-6 \
        # libxcb1 \
        # libxau6 \
        # libxdmcp6 \
        # libbsd0 \
        # libsm6 \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -ms /bin/bash -u ${UID} ${USERNAME} && \
    mkdir -m=0700 /home/${USERNAME}/.ssh/ && \
    chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.ssh/ && \
    ln -s /home/${USERNAME} /user-homedir && \
    cat /tmp/bash.bashrc >> /etc/bash.bashrc && \
    rm -f /tmp/bash.bashrc


USER ${USERNAME}
ENV HOME=/home/${USERNAME} \
    TERM=xterm-256color \
    SSH_AUTH_SOCK=/home/${USERNAME}/.ssh/ssh-auth.sock


WORKDIR /workspace
