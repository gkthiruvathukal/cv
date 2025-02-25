#!/bin/bash

if [ -d ~/.linuxbrew ]; then
  PATH=/usr/bin:$PATH
fi

[[ -d .venv ]] && source .venv/bin/activate

MAIN=cv-main

source data/personal-settings.sh
