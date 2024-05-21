FROM python:3.9.19-slim as base


FROM base as builder
# RUN apt update;
RUN apt-get update && apt-get install --no-install-recommends -y \   
    vim-tiny \
    libgl1 \
    libglib2.0-0 \
    libx11-6 \
    libxcb1 \
    libxau6 \
    libxdmcp6 \
    libbsd0 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


FROM base

ENV HOME=/root \
    TERM=xterm-256color

COPY --from=builder /usr/bin/vim.tiny /usr/bin/
COPY --from=builder \
    /usr/lib/x86_64-linux-gnu/libGL.so.1 \
    /usr/lib/x86_64-linux-gnu/libGLX.so.0 \
    /usr/lib/x86_64-linux-gnu/libGLdispatch.so.0 \
    /usr/lib/x86_64-linux-gnu/libgthread-2.0.so.0 \
    /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0 \
    /usr/lib/x86_64-linux-gnu/libX11.so.6 \
    /usr/lib/x86_64-linux-gnu/libxcb.so.1 \
    /usr/lib/x86_64-linux-gnu/libXau.so.6 \
    /usr/lib/x86_64-linux-gnu/libXdmcp.so.6	\
    /usr/lib/x86_64-linux-gnu/libbsd.so.0 \
    /usr/lib/x86_64-linux-gnu/
COPY bashrc $HOME/.bashrc

RUN ln -s /etc/alternatives/vi /usr/bin/vi; \
    ln -s /usr/bin/vim.tiny /etc/alternatives/vi

WORKDIR /workspace
