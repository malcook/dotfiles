#!/usr/bin/make -Rrf 

MAKEFILE=$(lastword $(MAKEFILE_LIST))
BINDIR:=$(dir $(abspath $(MAKEFILE)))
STOW:=stow
# $(filter --verbose,${MAKEFLAGS})
#FIND:=find
GIT:=git
#$(info info ${BIN} ${BINDIR})


all:=*.df
which:=${all}
list:=$(wildcard ${which})

help:
	@echo Targets: ${cmd}

list:
	@echo ${list}

bootstrap.deb:
	sudo apt-get -y install stow

startup:
# FIXME: currently only designed with bash in mind
#	@printf 'printing form  this in your .bash_profile (or eval it now)\n:' 1>&2
#	@printf 'eval $(~/.dotfiles/dotfiles startup)\n' 1>&2
#	@printf 'alias dotfiles="make -C ${BINDIR} -Rrf"\n'
#	@printf 'alias dotfiles="make -C ${BINDIR} -Rrf"\n'
	@printf 'alias dotfiles="make --no-print-directory -Rr -C ${BINDIR} "\n'

cmd=stow S delete D restow R
${cmd}:
	${STOW} --${@} ${list}


ignore:
# on a new machine
# install git some
	mkdir ${HOME}/.dotfiles
	${GIT} clone github/malcook dotfiles .dotfiles
	cd .dotfiles
	git init

# git submodule add https://github.com/anishathalye/dotbot
# cp dotbot/tools/git-submodule/install .
# touch install.conf.yaml
