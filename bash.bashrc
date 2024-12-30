

####
# bash.bashrc for devcontainer
####

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias ll="ls -lah --group-directories-first" 
alias less="less -Ri" 
alias mv="mv -i" 
alias cp='cp -i'
alias rm='rm -i'
alias vim="vi"


# add timestamp to history
export HISTTIMEFORMAT="%F %T  "

####
# bash.bashrc for devcontainer
####


