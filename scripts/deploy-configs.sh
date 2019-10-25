#!/bin/sh
set -e

# Deploy the configs on this machine to another machine via scp
# Deploy config on another server over scp
# $1 destination or user@destination
# exampe: cfgdeploy user@myserver

CONFIG_LIST=".bashrc .vimrc .vim/colors/skittles_dark_cw.vim .tmux.conf"

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 user@host" >&2
  exit 1
fi

for file in $CONFIG_LIST; do scp ~/$file $1:$file; done
