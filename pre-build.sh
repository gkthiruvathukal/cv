#!/bin/bash

rm -f bibliography/*-raw.bib

source ./build-settings.sh

echo "Generating main LaTeX source"
tools/instantiate-cv-template.py

echo "Fetching bibliography from Zotero"
tools/get-zotero-bibtex.sh

echo "Sanitizing downloaded bib files"

for bibfile in bibliography/*.bib
do
    bibfile_raw="${bibfile%.bib}-raw.bib"
    mv "$bibfile" "$bibfile_raw" 
    tools/sanitize-zotero-bib.py "$bibfile_raw" "$bibfile"
done

if [[ -n "${GSCHOLAR_PROFILE}" ]]; then
    echo "Obtaining Google Scholar data for $GSCHOLAR_PROFILE"
    python3 tools/scholarly-metrics.py --profile "$GSCHOLAR_PROFILE" > /dev/null
fi

touch 99-scholarly-bibliometrics.tex

if [[ -n "${GITHUB_USER}" ]]; then
    echo "Obtaining GitHub contribution data"
    datecmd=$(which gdate)
    [[ -x "$datecmd" ]] || datecmd=$(which date)
    first_year=$($datecmd --date="5 years ago" +%Y)
    last_year=$($datecmd --date="1 year ago" +%Y)
    python3 tools/github-commits.py  --first-year $first_year --last-year $last_year --username $GITHUB_USER --modern-cv
fi
touch 99-github-contributions.tex
