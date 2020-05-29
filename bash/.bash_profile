export PATH=$PATH:${HOME}/edirect
export GOPATH=${HOME}/.local/go
export PATH=${PATH}:${GOPATH//://bin:}/bin

export PATH=~/local/bin:${PATH}
export MANPATH=~/local/share/man:${MANPATH}

# env -i FOO=BAR HOME=$HOME  bash --login -i  -c ' (env)' 


# for f in ${BASH_SOURCE}.d/*.sh; do source $f  ; done
# USER=$(dirname ${BASH_SOURCE})
# source ${USER}/.profile
# source ${USER}/.bashrc

# SSHAGENT=/usr/bin/ssh-agent
# SSHAGENTARGS="-s"
# if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
#     eval `$SSHAGENT $SSHAGENTARGS`
#     eval `ssh-add ~/.ssh/id_rsa`
#     trap "kill $SSH_AGENT_PID" 0
# fi


# when do I have to do this - every reboot - evey login?
#eval "$(ssh-agent -s)"
#ssh-add ~/.ssh/id_rsa


##https://github.com/magicmonty/bash-git-prompt
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
