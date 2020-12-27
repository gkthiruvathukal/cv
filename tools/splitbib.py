#!/usr/bin/env python

import sys
bib = sys.argv[1]
out_dir = sys.argv[2]
import os
os.makedirs(out_dir)
out_name = "%(year)s-%(ENTRYTYPE)s-%(ID)s.bib"

import bibtexparser
from bibtexparser.bwriter import BibTexWriter
from bibtexparser.bibdatabase import BibDatabase

with open(bib) as bibtex_file:
    bib_database = bibtexparser.load(bibtex_file)

for entry in bib_database.entries:
    db = BibDatabase()
    db.entries = [entry]
    writer = BibTexWriter()
    out_filename = out_name % entry
    out_filename = out_filename.replace('/','_')
    out_path = os.path.join(out_dir, out_filename)
    with open(out_path, 'w') as bibfile:
       bibfile.write(writer.write(db))

