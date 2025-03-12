#!/bin/bash

source ./build-settings.sh

# Every entry in the .bib MUST have a year to sort properly. (We don't rigidly sort by other fields, month, day, since these don't always appear).

./pre-build.sh

echo "Building LaTeX document"
latexmk -output-directory="./build" -C -pdf ${MAIN}.tex
latexmk -output-directory="./build" -pdf ${MAIN}.tex

if [ -f build/${MAIN}.pdf ]; then
  if [ -d ../${DOMAIN} ]; then
    mkdir -p ../${DOMAIN}/_bibliography
    cat bibliography/*.bib > ../${DOMAIN}/_bibliography/papers.bib
    echo "Copied latest bibliography to website folder"
  fi 
fi
