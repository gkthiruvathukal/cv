#!/bin/bash


MAIN=gkthiruvathukal-cv

# Each of my BibTeX entries is kept in a separate file and assembled into one (for each type of publication).
# Makes it easier to keep up-to-date.
# Every entry in the .bib MUST have a year to sort properly. (We don't rigidly sort by other fields, month, day, since these don't always appear).

pushd bibs >& /dev/null
bash gather.sh
popd >& /dev/null

sleep 5

latexmk -output-directory="./build" -C -pdf ${MAIN}.tex
latexmk -output-directory="./build" -pdf ${MAIN}.tex

if [ -f build/gkthiruvathukal-cv.pdf ]; then
  if [ -d ../gkthiruvathukal.github.io ]; then
     cat bibliography/*.bib > ../gkthiruvathukal.github.io/_bibliography/papers.bib
     echo "Copied latest bibliography to gkthiruvathukal.github.io folder (locally)"
  fi 
fi
