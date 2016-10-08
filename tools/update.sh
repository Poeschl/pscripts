#!/usr/bin/env bash
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

printf "${BLUE}%s${NORMAL}\n" "Updating pscripts..."
cd "$PSCRIPTS"

git reset --hard
if git pull --rebase --stat origin master
then
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
  printf "${BLUE}%s\n" "Yey, its updated and/or is at the latest version."
else
  printf "${BOLD}%s${NORMAL}\n" 'There was an error updating. Try again later?'
fi
