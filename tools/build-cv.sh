#!/bin/bash

MAIN=gkthiruvathukal-cv

if [ -d ~/.linuxbrew ]; then
  PATH=/usr/bin:$PATH
fi

if [ -f ~/zenv/bin/activate ]; then
  source ~/zenv/bin/activate
fi

if [ ! -f ${MAIN}.tex ]; then
   echo "Must run in the directory containing ${MAIN}.tex"
   exit 1
fi

echo "Obtaining Google Scholar Data"
python tools/scholarly-metrics.py --name "George K. Thiruvathukal"
sleep 5

latexmk -output-directory="./build" -C -pdf ${MAIN}.tex
latexmk -output-directory="./build" -pdf ${MAIN}.tex
