#!/usr/bin/make -Rrf 

MAKEFILE=$(lastword $(MAKEFILE_LIST))
BINDIR:=$(dir $(abspath $(MAKEFILE)))
STOW:=stow
##$(filter --dry-run -n
# $(filter --verbose,${MAKEFLAGS})
#FIND:=find
GIT:=git
#$(info info ${BIN} ${BINDIR})

help: package.names command.names
	@echo make  Targets: ${command.names}


#all:=*.df
#which:=${all}
#packages:=$(wildcard ${which})

command.names=stow S delete D restow R

package.names:=$(notdir $(shell find ${BINDIR}* -maxdepth 0 -type d))

packages=${package.names}

stowall:
	stow --stow ${package.names}

${command.names}:
	${STOW} --${@} ${packages}

package.names command.names:
	@echo $@: ${$@}

bootstrap.deb:
	apt-get -y install stow

bootstrap.rhel:
	yum -y install stow

startup:
# FIXME: currently only designed with bash in mind
#	@printf 'printing form  this in your .bash_profile (or eval it now)\n:' 1>&2
#	@printf 'eval $(~/.dotfiles/dotfiles startup)\n' 1>&2
#	@printf 'alias dotfiles="make -C ${BINDIR} -Rrf"\n'
#	@printf 'alias dotfiles="make -C ${BINDIR} -Rrf"\n'
	@printf 'alias dotfiles="make --no-print-directory -Rr -C ${BINDIR} "\n'

ignore:
# on a new machine
# install git some
#	mkdir ${HOME}/.dotfiles
#	git init
	cd ${HOME}
	${GIT} clone github/malcook dotfiles .dotfiles
	cd .dotfiles
	stow

# git submodule add https://github.com/anishathalye/dotbot
# cp dotbot/tools/git-submodule/install .
# touch install.conf.yaml
