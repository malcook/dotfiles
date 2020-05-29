#export GDK_NATIVE_WINDOWS=1

## emacs, which may already be running, is both my VISUAL editor and
## my no-windows EDITOR:
## NB: VISUAL is invoked to edit the current line  c-x c-e in the bash shell.
## use a -c if you want a new frame.
export ALTERNATE_EDITOR='emacs -nw'
export VISUAL='emacsclient -a="emacs -nw"'
# -c  create a new frame
export EDITOR="${VISUAL} -nw"
alias e=${VISUAL}
## typically called as `e -n file/path.txt`


