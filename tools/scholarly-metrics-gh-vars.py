#!/usr/bin/env python3

import os

BIBLIOMETRICS_TEX = """
\\cvline{Citations}{%(citedby)s on \\href{%(scholar_url)s}{Google Scholar}}
\\cvline{h-index}{%(hindex)s}
\\cvline{i10-index}{%(i10index)s}
"""

import argparse

def get_argparse():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '--output', help="output filename", default="99-scholarly-bibliometrics.tex", required=False)
    return parser

parser = get_argparse()
args = parser.parse_args()

required_vars = [
  'CV_GSCHOLAR_ID',
  'CV_GSCHOLAR_CITATIONS',
  'CV_GSCHOLAR_H_INDEX',
  'CV_GSCHOLAR_I10_INDEX',
]

ev_cache = { var : os.environ.get(var, None) for var in required_vars }
fail = False

# This could be more functional; however, we need to have messages if any variable is not set properly.
for (var, value) in ev_cache.items():
   if not value:
      print("environment variable %(var)s not defined" % vars())
      fail = True

if fail:
   exit(1)

scholar_id = ev_cache['CV_GSCHOLAR_ID']
SCHOLAR_URL="https://scholar.google.com/citations?hl=en\\&user=%(scholar_id)s"
scholar_url = SCHOLAR_URL % vars()

bibliographic_vars = {
  'citedby' : ev_cache['CV_GSCHOLAR_CITATIONS'],
  'hindex' : ev_cache['CV_GSCHOLAR_H_INDEX'],
  'i10index' : ev_cache['CV_GSCHOLAR_I10_INDEX'],
  'scholar_url' : scholar_url }

with open(args.output, "w") as out_file:
   out_file.write(BIBLIOMETRICS_TEX % bibliographic_vars)







