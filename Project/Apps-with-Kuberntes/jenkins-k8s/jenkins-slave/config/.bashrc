# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
PATH=$PATH:$HOME/.local/bin:$HOME/bin
PATH=/opt/google-cloud-sdk/bin:/usr/bin/docker:/usr/bin/mvn:$PATH

export PATHTH=$PATH:$HOME/.local/bin:$HOME/bin
PATH=/opt/google-cloud-sdk/bin:/usr/bin/docker:/usr/bin/mvn:$PATH

export PATH
