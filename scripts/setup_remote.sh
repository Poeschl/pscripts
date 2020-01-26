#!/bin/sh
set -e

# Setup a remote linux with default tools and copy the configs
# $1 destination or user@destination
# exampe: setup_remote user@myserver

hostname=$1

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 user@host" >&2
  exit 1
fi

echo "Provision $hostname"

read -p 'Set hostname: ' -r
new_hostname=$REPLY

echo 'Copy ssh key'
ssh-copy-id -i ~/.ssh/id_rsa "$hostname"

echo 'Install packages'

ssh "$hostname" sudo apt-get update \
	&& sudo apt-get -y install git libgnome-keyring-dev \
	&& sudo make --directory=/usr/share/doc/git/contrib/credential/gnome-keyring \
	&& git config --global credential.helper /usr/share/doc/git/contrib/credential/gnome-keyring/git-credential-gnome-keyring \
	&& git config --global core.autocrlf input \
\
	&& sudo apt-get -y install vim \
\
	&& sudo apt-get -y install wget zsh fonts-powerline \
	&& pip3 install thefuck \
	&& wget -O oh-my-zsh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh \
	&& sudo chmod u+x oh-my-zsh \
	&& ./oh-my-zsh --unattended \
	&& rm -rf oh-my-zsh \
	&& sed -i "/^ZSH_THEME/s/\".*\"/\"agnoster\"/" ~/.zshrc \
	&& sed -i "/^plugins/s/(.*)/(gitfast pip python thefuck shrink-path)/" ~/.zshrc \
	&& touch ~/.zshenv \
	&& mkdir -p "${HOME}/.local/bin" \
	&& echo 'PATH=~/.local/bin:${PATH}' > ~/.zshenv \
	&& echo "DEFAULT_USER=${USER}" > ~/.zshenv \
	&& echo "EDITOR=vim" > ~/.zshenv \
	&& sudo chsh -s /usr/bin/zsh "$USER" \
	&& sed -i -e '$a\\nprompt_dir () {\n\tprompt_segment blue black "`shrink_path -f`"\n}' ~/.zshrc \
\
	&& sudo apt-get -y install tmux \
	&& git clone https://github.com/gpakosz/.tmux.git \
	&& ln -s -f .tmux/.tmux.conf \
	&& wget -O ./.tmux.conf.local https://raw.githubusercontent.com/Poeschl/pscripts/ubuntu-setup/config/.tmux.conf.local \
    && sed -i "/^plugins=(.*/s/)/ tmux)/" ~/.zshrc \
	&& sed -i '/^export ZSH=".*"/aexport ZSH_TMUX_AUTOSTART=true' ~/.zshrc

echo 'Setup environment'
deploy_config $1

echo 'Set hostname'
ssh "$hostname" CUSTOM_HOSTNAME=$new_hostname sudo $CUSTOM_HOSTNAME > /etc/hostname
