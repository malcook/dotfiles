alias paths='echo $PATH | perl -pi -e "s/:/\n/g"'
alias la='ls -la'

function sub {
    job="$@"
    ${job}; kdialog --passivepopup "$? returned by: '$@'"
}

#alias rm='rm -i'
#alias cp='cp -i'
#alias mv='mv -i'
#alias mkdir='mkdir -p'
#alias vi='vim'
#alias ls='ls --color=auto'

