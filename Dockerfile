FROM python:3-slim as base


FROM base


ARG USERNAME=service
ARG UID=2000


COPY bash.bashrc /tmp/bash.bashrc 
RUN apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
        gpg \
        iputils-ping \
        less \
        openssh-client \
        socat \
        sshpass \
        vim-tiny \
        wget \
    && wget -O- "https://keyserver.ubuntu.com/pks/lookup?fingerprint=on&op=get&search=0x6125E2A8C77F2818FB7BD15B93C4A3FD7BB9C367" | gpg --dearmour -o /usr/share/keyrings/ansible-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/ansible-archive-keyring.gpg] http://ppa.launchpad.net/ansible/ansible/ubuntu jammy main" | tee /etc/apt/sources.list.d/ansible.list \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
        ansible-core \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -ms /bin/bash -u ${UID} ${USERNAME} \
    && ln -s /home/${USERNAME} /user-homedir \
    && mkdir -m=0700 /user-homedir/.ssh/ \
    && mkdir -p -m=0755 /user-homedir/.ansible/collections/ansible_collections \
    && chown -R ${USERNAME}:${USERNAME} /user-homedir/ \
    && cat /tmp/bash.bashrc >> /etc/bash.bashrc \
    && rm -f /tmp/bash.bashrc


USER ${USERNAME}
ENV HOME=/home/${USERNAME} \
    TERM=xterm-256color \
    SSH_AUTH_SOCK=/home/${USERNAME}/.ssh/ssh-auth.sock


WORKDIR /workspaces
CMD [ "sleep", "infinity" ]