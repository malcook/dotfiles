sudo add-apt-repository ppa:git-core/ppa # want newer git
sudo apt-get upgrade
sudo apt-get update git

# set up new machine 

## install emacs
sudo apt-get build-dep emacs24
sudo apt-get install checkinstall
mkdir -p ~/src
cd ~/src
wget http://ftp.gnu.org/gnu/emacs/emacs-24.5.tar.gz
tar xf emacs-24.5.tar.gz
cd emacs-24.5
./configure
make
sudo checkinstall

# setup ${HOME}/local 
mkdir -p  ${HOME}/.local/{bin,etc,etc/profile.d,games,include,lib,lib64,man,sbin,share,src}

# gdrive following https://github.com/prasmussen/gdrive
wget -O  ~/.local/bin/gdrive  https://docs.google.com/uc?id=0B3X9GlR6EmbnWksyTEtCM0VfaFE&export=download 

# []? install and use http://sparkleshare.org/

# zotero
# TODO: recipe
# autostart zotero on login by adding file:~/.config/autostart/zotero.desktop

# [] setup pdf cloud repo for zotero
# following: [[https://forums.aws.amazon.com/thread.jspa?messageID=249270][Accessing Amazon S3 via WebDav]]

