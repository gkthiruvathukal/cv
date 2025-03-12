#!/bin/bash

# https://www.zotero.org/groups/5882358/laufer-incollection


BIB_DIR=bibliography
ZOTERO_BIB_URLS=data/zotero-bibs.txt
ZOTERO_API=https://api.zotero.org

mkdir -p $BIB_DIR

for u in $(cut -d/ -f 5-6 $ZOTERO_BIB_URLS) ; do

  GROUP_ID="${u%/*}"
  OUTPUT_FILE="$BIB_DIR/${u#*/}.bib"

  echo curl -L "$ZOTERO_API/groups/$GROUP_ID/items/top?format=biblatex&limit=100" -o "$OUTPUT_FILE"
  curl -L "$ZOTERO_API/groups/$GROUP_ID/items/top?format=biblatex&limit=100" -o "$OUTPUT_FILE"

  echo "BibLaTeX file downloaded: $OUTPUT_FILE"

done
