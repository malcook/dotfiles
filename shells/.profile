# ~/.profile: executed by the command interpreter for login shells.
time > ~/date.log
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.  In my case ~/.bash_profile exists.

# The default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.

#umask 022

for f in  ${BASH_SOURCE}.d/*.sh; do source $f  ; done

### when running bash, include .bashrc if it exists:
### NO!  This should be done by .bash_profile.
# if [ -n "$BASH_VERSION" ]; then
#     if [ -f "$HOME/.bashrc" ]; then
# 	. "$HOME/.bashrc"
#     fi
# fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi



## following should probably be
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
## without which:
## pyenv shell 2.7.13
## pyenv: no such command `shell'
