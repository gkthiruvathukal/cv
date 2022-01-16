#!/bin/bash

if [ -d ~/.linuxbrew ]; then
  PATH=/usr/bin:$PATH
fi

MAIN=gkthiruvathukal-cv

# Each of my BibTeX entries is kept in a separate file and assembled into one (for each type of publication).
# Makes it easier to keep up-to-date.
# Every entry in the .bib MUST have a year to sort properly. (We don't rigidly sort by other fields, month, day, since these don't always appear).

echo "Collating bibliography"
pushd bibs >& /dev/null
bash gather.sh
popd >& /dev/null
sleep 5

echo "Obtaining Google Scholar Data"
python tools/scholarly-metrics.py --name "George K. Thiruvathukal"
python3 tools/github-commits.py  --first-year 2015 --last-year 2022 --username gkthiruvathukal
sleep 5

latexmk -output-directory="./build" -C -pdf ${MAIN}.tex
latexmk -output-directory="./build" -pdf ${MAIN}.tex

if [ -f build/gkthiruvathukal-cv.pdf ]; then
  if [ -d ../gkt.cs.luc.edu ]; then
     cat bibliography/*.bib > ../gkt.cs.luc.edu/_bibliography/papers.bib
     echo "Copied latest bibliography to website folder"
  fi 
fi
