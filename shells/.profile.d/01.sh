# ~/.dotfiles/shells/.profile.d/
## AVOID ** (emacs:14241): WARNING **: Couldn't connect to accessibility bus: Failed to connect to socket /tmp/dbus-TVF0J1jmGM: Connection refused
## c.f. http://askubuntu.com/questions/432604/couldnt-connect-to-accessibility-bus.
export NO_AT_BRIDGE=1
