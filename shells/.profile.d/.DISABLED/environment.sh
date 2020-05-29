#!/usr/local/bin/bash

umask 022			# everyone to read files I create

export PS1='\u@\h> '		# user@hostname 

#export BROWSER=`which firefox`
#export pushdtohome=1
#export pushdsilent=1
#export rmstar=1
#export visiblebell=1

#if [ "$TERM" == "xterm" ]; then
#	stty erase '^H'
#fi

#  If autolist is set to `ambiguous', choices are listed only when completion
#  fails and adds no new characters to the word being completed.
#export autolist ambiguous

# The shell variable fignore can be set to a list of suffixes to be ignored
#  by completion. 
#export FIGNORE=~
#  autoexpand can be set to run the expand-history editor command
#  before each completion attempt,
#export autoexpand

#  autocorrect can be set to spelling-correct
#  the word to be completed (see Spelling correction) before each completion
#  attempt
#export autocorrect

# and correct can be set to complete commands automatically after one
#  hits `return'. 

#  matchbeep can be set to make completion beep or not beep in
#  a variety of situations, and nobeep can be set to never beep at all.  nos-
#  tat can be set to a list of directories and/or patterns which match direc-
#  tories to prevent the completion mechanism from stat(2)ing those direc-
#  tories.  listmax and listmaxrows can be set to limit the number of items
#  and rows (respectively) that are listed without asking first.

#set ignoreeof=1
#export implicitcd=1
#export listjobs=long
#export notify=1
#export printexitvalue=1
#export nobeep=1

alias findpath='find ${PATH//:/ }'
##example usage: `pathfind -regex '.*mysql'`


#PATH="$HOME/local/bin:${PATH}"
#PATH="${HOME}/local/texlive/2013/bin/x86_64-linux:$PATH "

export LD_LIBRARY_PATH="/usr/lib64/:${LD_LIBRARY_PATH}"
#export LD_LIBRARY_PATH="/usr/lib64/mysql:${LD_LIBRARY_PATH}"

export LD_LIBRARY_PATH="$HOME/local/lib:${LD_LIBRARY_PATH}"
export LD_LIBRARY_PATH="$HOME/local/lib64:${LD_LIBRARY_PATH}"
MANPATH="$HOME/local/man:${MANPATH}"

export MANPATH="${HOME}/local/share/man/:${HOME}/local/man:${MANPATH}"
export PATH="${HOME}/local/bin:${PATH}"

#export PATH="${PATH}:/n/site/inst/Linux-x86_64/bioinfo/genometools/current/bin/"

# pick up my compilation of coreutils (until Brandon is ready to
# install site-wide???)
#export PATH=~/local/src/coreutils-8.6/src:"${PATH}"
#export MANPATH=~/local/src/coreutils-8.6/man:"${MANPATH}"
#export PATH=/n/site/src/bioinfo/ncbi/ncbi-blast-2.2.24+-src/c++/ReleaseMT/bin:"${PATH}"


################################################################################

# following is now redundant, since 'all the Linux servers (and helix)
# aren't blocked on port 80.' (per dct - 4/5/2005).

#unexport HTTP_PROXY http://proxykc04:8080/ 
#unexport http_proxy ${HTTP_PROXY}
#needed for: cpan and seqhound and !?!?!?

#the following is for Jim Kent's utils which I have built in ~cvs/kent/src and which got installed in ~/bin/kentCurrent_x86_64  (see ~/cvs/kent/SIMRNOTES.txt)

# export PATH=~/bin/kentCurrent_x86_64/:${PATH}	
# #this should be done in either case
# export PATH=~/bin/`uname -m`/:${PATH}
