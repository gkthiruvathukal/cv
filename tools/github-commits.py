#!/usr/bin/env python
import xml.etree.ElementTree as ET
import requests
import argparse

from functools import reduce

CVLINE='\cvline{GitHub}{%(commits)s contributions from %(first_year)s to %(last_year)s}\n'

def get_argparse():
    parser = argparse.ArgumentParser()

    parser.add_argument(
        '--username', help="GitHub username", required=True)
    parser.add_argument(
        '--first-year', type=int, help="First Year", required=True)
    parser.add_argument(
        '--last-year', type=int, help="Last Year", default=0, required=False)
    parser.add_argument(
        '--raw', type=bool, help="output raw number", default=False, required=False)
    parser.add_argument(
        '--modern-cv', type=bool, help="output cvline for modern-cv", default=True, required=False)
    parser.add_argument(
        '--output', help="output filename", default="github-contributions.tex", required=False)
    return parser

parser = get_argparse()
args = parser.parse_args()

if args.last_year < args.first_year:
    args.last_year = args.first_year

commit_sum = 0
for year in range(args.first_year, args.last_year + 1):
   payload = {'to': '-'.join([str(year), '12', '31'])}
   request = requests.get('https://github.com/users/%(username)s/contributions' % vars(args), params=payload)
   with open('/tmp/some.xml', 'w') as outfile:
       outfile.write(request.text)
   tree = ET.parse('/tmp/some.xml')

   for element in tree.findall(".//svg/g/g/rect"):
       commit_sum += int(element.attrib['data-count'])
   
if args.raw:
   print(commit_sum)

if args.modern_cv:
   cvline_vars = { 'commits' : commit_sum, 'first_year' : args.first_year, 'last_year' : args.last_year }
   with open(args.output, "w") as outfile:
      outfile.write(CVLINE % cvline_vars)
