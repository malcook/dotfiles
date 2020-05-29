    if [ -e $simr_dotfiles_prefix/etc/profile ]; then
	. $simr_dotfiles_prefix/etc/profile
    elif [ -e /n/site/inst/shared/bash/init.sh ]; then
	. /n/site/inst/shared/bash/init.sh
    fi


if [ $(dnsdomainname) == "sgc.loc" ] ; then

    ##export PRINTER=PC010301
    export PRINTER=mfp020502

    export CVSROOT="adminkc02:/data1/cvs"

    function smux { ssh "$@" -t tmux a ; }
    
    alias mangox="ssh mango -t tmux a"
fi
