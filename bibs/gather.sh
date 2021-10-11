#!/bin/bash

DEST=../bibliography
mkdir -p $DEST/
if [ ! -d "$DEST" ]; then
  echo "Could not create target $DEST (fatal)"
  exit 1
fi

for bibtype in books inproceedings journal magazine misc techreport theses incollection; do
  echo "Processing $bibtype"
  BIBFILE=$DEST/${bibtype}.bib
  > $BIBFILE
  for entry in $(ls -r ${bibtype}/*.bib); do
    cat "$entry" >> $BIBFILE
  done
done


# Can probably let the CI system put all of these files together...
#> $DEST/gkt-all.bib
#for bibtype in books inproceedings journal magazine misc techreport theses; do
#  echo adding $DEST/${bibtype}.bib to $DEST/gkt-all.bib
#  cat $DEST/${bibtype}.bib >> $DEST/gkt-all.bib
#done
  
