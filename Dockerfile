FROM python:3.9.19-alpine as base


FROM base as builder
RUN apk update;


FROM base

ENV HOME=/root
ENV ENV=$HOME/.ashrc

# COPY --from=builder $HOME/.ashrc $HOME/.ashrc
RUN echo -e '\
alias ll="ls -lah --group-directories-first" \n\
alias mv="mv -i" \n\
alias less="less -Ri" \n\
alias vim="vi" \
' >> $HOME/.ashrc

WORKDIR /workspace
