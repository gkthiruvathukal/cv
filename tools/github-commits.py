#!/usr/bin/env python
#import xml.etree.ElementTree as ET
from bs4 import BeautifulSoup
import requests
import argparse

from functools import reduce

CVLINE='\cvline{GitHub}{%(commits)s contributions from %(first_year)s-%(last_year)s at \href{https://github.com/%(username)s}{GitHub}}\n'

def get_argparse():
    parser = argparse.ArgumentParser()

    parser.add_argument(
        '--username',
        help="GitHub username",
        required=True)

    parser.add_argument(
        '--first-year',
        type=int,
        help="First Year",
        required=True)

    parser.add_argument(
        '--last-year',
        type=int,
        help="Last Year",
        default=0,
        required=False)

    parser.add_argument(
        '--raw',
        help="output raw number",
        const=True,
        required=False,
        action='store_const')

    parser.add_argument(
        '--modern-cv',
        const=True,
        help="output cvline for modern-cv", 
        required=False,
        action='store_const')

    parser.add_argument(
        '--output',
        help="output filename",
        default="github-contributions.tex",
        required=False)
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

   soup = BeautifulSoup(request.text, features="html.parser")

   for rect in soup.find_all("rect"):
       commit_sum += int(rect.get('data-count', 0))
   
if args.raw:
   print(commit_sum)

if args.modern_cv:
   cvline_vars = { 'commits' : commit_sum, 'first_year' : args.first_year, 'last_year' : args.last_year, 'username' : args.username}
   with open(args.output, "w") as outfile:
      outfile.write(CVLINE % cvline_vars)
