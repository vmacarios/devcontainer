FROM python:3.13-slim as base


FROM base


ARG USERNAME=service
ARG UID=2000


COPY bash.bashrc /tmp/bash.bashrc 
RUN apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
        gpg \
        iputils-ping \
        less \
        locales \
        openssh-client \
        socat \
        sshpass \
        vim-tiny \
        wget \
    && wget -O - "https://apt.releases.hashicorp.com/gpg" | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com bookworm main" | tee /etc/apt/sources.list.d/hashicorp.list \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
        terraform \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -ms /bin/bash -u ${UID} ${USERNAME} \
    && ln -s /home/${USERNAME} /user-homedir \
    && mkdir -m=0700 /user-homedir/.ssh/ \
    && mkdir -p -m=0755 /user-homedir/.ansible/collections/ansible_collections \
    && chown -R ${USERNAME}:${USERNAME} /user-homedir/ \
    && cat /tmp/bash.bashrc >> /etc/bash.bashrc \
    && rm -f /tmp/bash.bashrc \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen \
    && pip install --no-cache-dir \
        ansible-core


USER ${USERNAME}
ENV HOME=/home/${USERNAME} \
    TERM=xterm-256color \
    SSH_AUTH_SOCK=/home/${USERNAME}/.ssh/ssh-auth.sock
RUN terraform -install-autocomplete


WORKDIR /workspaces
CMD [ "sleep", "infinity" ]