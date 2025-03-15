#!/bin/bash


# Discover HomeBrew:
# - Start from user/home directory install default (on Linux)
# - Then try $HOME/.linuxbrew
# - Then try /opt/homebrew for Mac ARM
# - Then try /usr/local for Mac x86 (on its way out)

for dir in /home/linuxbrew/.linuxbrew $HOME/.linuxbrew /opt/homebrew /usr/local; do
   if [ -f "$dir/bin/brew" ]; then
      BREW_HOME="$dir"
      echo "brew found in ${BREW_HOME}"
      eval "$($BREW_HOME/bin/brew shellenv)"
      break
   fi
done 


# Search for .venv in $(pwd) and home dir (~)
#
for basedir in $(pwd) ~; do
  dir=${basedir}/.venv
  echo "Searching for .venv in ${basedir}"
  [[ -d "${dir}" ]] && source "${dir}/bin/activate" && break
done

echo "python3 found in $(which python3)"

MAIN=cv-main

source data/personal-settings.sh
