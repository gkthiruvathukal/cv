[![Deploy CV](https://github.com/klaeufer/cv/actions/workflows/main.yml/badge.svg)](https://github.com/klaeufer/cv/actions/workflows/main.yml)

# Curriculum Vitae

This is my CV in LaTeX based on the [moderncv](https://ctan.org/pkg/moderncv) class following [gkthiruvathukal's example](https://github.com/gkthiruvathukal/cv).

You can view/download the latest version [here](https://github.com/klaeufer/cv/releases/latest/download/klaeufer.pdf).

All personal information is in LaTeX sources in the `./data` subdirectory, from which the main LaTeX source gets generated automatically:

- We fetch the bibliography data from the Zotero group URLs in `zotero-bibs.txt`.
- `data/personal-settings.sh` contains these settings:

  - `FULLNAME` for the Google Scholar data
  - `GITHUB_USER` for the activity stats
  - `DOMAIN`, optional local directory, parallel to this repo, containing the user's static website source; the collated bib gets copied to `../${DOMAIN}/_bibliography/papers.bib`

- Files named `0[0-9]-*.tex` become part of the document *preamble*.
- Files named `[1-9][0-9]-*.tex` constitute the document *body*.
- The files `99-github-contributions.tex` and `99-scholarly-bibliometrics.tex` are generated automatically and can be included in a section of the document body.
