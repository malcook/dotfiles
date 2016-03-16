export PATH=$PATH:${HOME}/edirect
export GOPATH=${HOME}/.local/go
export PATH=${PATH}:${GOPATH//://bin:}/bin


# env -i FOO=BAR HOME=$HOME  bash --login -i  -c ' (env)' 


for f in ${BASH_SOURCE}.d/*.sh; do source $f  ; done
USER=$(dirname ${BASH_SOURCE})
source ${USER}/.profile
source ${USER}/.bashrc

