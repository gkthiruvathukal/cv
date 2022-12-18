#!/usr/bin/env python3


BIBLIOMETRICS_TEX = """
\section*{Bibliometrics}

\cvline{Citations}{%(citedby)s on \href{%(scholar_url)s}{Google Scholar}}
\cvline{h-index}{%(hindex)s}
\cvline{i10-index}{%(i10index)s}
"""

SCHOLAR_URL="https://scholar.google.com/citations?hl=en\\&user=%(scholar_id)s"

import argparse
import json
from scholarly import scholarly

def get_argparse():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '--name', help="scholar's name", required=True)
    parser.add_argument(
        '--output', help="output filename", default="scholarly-bibliometrics.tex", required=False)
    return parser


parser = get_argparse()
args = parser.parse_args()

search_query = scholarly.search_author(args.name)
author = next(search_query)

data = scholarly.fill(author, sections=['basics', 'indices', 'coauthors'])

print(json.dumps(data, indent=3))

scholar_url = SCHOLAR_URL % author

#scholar_url = scholar_url.replace('_',r'\_')

bibliographic_vars = {
  'citedby' : author['citedby'],
  'hindex' : author['hindex'],
  'i10index' : author['i10index'],
  'scholar_url' : scholar_url }

with open(args.output, "w") as out_file:
   out_file.write(BIBLIOMETRICS_TEX % bibliographic_vars)







