#!/usr/bin/env bash
main() {
  # Use colors, but only if connected to a terminal, and that terminal
  # supports them.
  if which tput >/dev/null 2>&1; then
      ncolors=$(tput colors)
  fi
  if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    BOLD="$(tput bold)"
    NORMAL="$(tput sgr0)"
  else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    NORMAL=""
  fi

  # Only enable exit-on-error after the non-critical colorization stuff,
  # which may fail on systems lacking tput or terminfo
  set -e

  envExists=0
  if [ ! -n "$PSCRIPTS" ]; then
    PSCRIPTS=~/.pscripts
    envExists=1
  fi


  if [ -d "$PSCRIPTS" ]; then
    printf "${YELLOW}You already have the pscripts installed.${NORMAL}\n"
    printf "Please remove $PSCRIPTS before a re-install.\n"
    exit
  fi

  # Prevent the cloned repository from having insecure permissions. Failing to do
  # so causes compinit() calls to fail with "command not found: compdef" errors
  # for users with insecure umasks (e.g., "002", allowing group writability). Note
  # that this will be ignored under Cygwin by default, as Windows ACLs take
  # precedence over umasks except for filesystems mounted with option "noacl".
  umask g-w,o-w

  printf "${BLUE}Cloning pscripts...${NORMAL}\n"
  hash git >/dev/null 2>&1 || {
    echo "Error: git is not installed"
    exit 1
  }

  git clone --depth=1 https://github.com/Poeschl/pscripts.git $PSCRIPTS
  if [ ! $? -eq 0 ]
  then
    printf "Error: git clone of pscript repo failed\n"
    exit 1
  fi

  printf "${BLUE}Setup pscripts...${NORMAL}\n"

  if [ $envExists="0" ];
  then
    printf "${BLUE}Add stuff to .zshenv ...${NORMAL}\n"
    export PSCRIPTS=$PSCRIPTS
    echo "export PSCRIPTS=$PSCRIPTS" >> ~/.zshenv
    echo "export PATH=\$PATH:\$PSCRIPTS/scripts" >> ~/.zshenv
  fi

  printf "${RED}"
  echo ' _______  _______  _______  _______ _________ _______ _________ _______ '
  echo '(  ____ )(  ____ \(  ____ \(  ____ )\__   __/(  ____ )\__   __/(  ____ \'
  echo '| (    )|| (    \/| (    \/| (    )|   ) (   | (    )|   ) (   | (    \/'
  echo '| (____)|| (_____ | |      | (____)|   | |   | (____)|   | |   | (_____ '
  echo '|  _____)(_____  )| |      |     __)   | |   |  _____)   | |   (_____  )'
  echo '| (            ) || |      | (\ (      | |   | (         | |         ) |'
  echo '| )      /\____) || (____/\| ) \ \_____) (___| )         | |   /\____) |'
  echo '|/       \_______)(_______/|/   \__/\_______/|/          )_(   \_______)'
  echo ''
  echo 'is now installed.'

}

main
