#!/bin/bash

source ./build-settings.sh

echo "Generating main LaTeX source"
tools/generate-main-tex.sh

echo "Fetching bibliography from Zotero"
tools/get-zotero-bibtex.sh

echo "Obtaining Google Scholar data"
python3 tools/scholarly-metrics.py --name "$FULLNAME" > /dev/null

echo "Obtaining GitHub contribution data"
datecmd=$(which gdate)
[ -x "$datecmd" ] || datecmd=$(which date)
first_year=$($datecmd --date="5 years ago" +%Y)
last_year=$($datecmd --date="1 year ago" +%Y)
python3 tools/github-commits.py  --first-year $first_year --last-year $last_year --username $GITHUB_USER --modern-cv
sleep 5
