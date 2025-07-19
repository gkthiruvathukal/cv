#!/usr/bin/env python3

import argparse
import subprocess
from datetime import datetime, timezone
from scholarly import scholarly

DEFAULT_REPO = "gkthiruvathukal/cv"
DEFAULT_PROFILE = 'Ls7yS0IAAAAJ'

def get_argparse():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '--profile',
        help="Google Scholar profile ID",
        default=DEFAULT_PROFILE,
    )
    parser.add_argument(
        '--gh-repo',
        help="GitHub repo in format user/repo",
        default=DEFAULT_REPO
    )
    parser.add_argument(
        '--pretend',
        action='store_true',
        help="Print the gh commands without executing them"
    )
    return parser

def set_gh_variable(name, value, repo, pretend=False):
    cmd = ["gh", "variable", "set", name, "--body", str(value), "--repo", repo]
    print(f"{'[DRY RUN]' if pretend else 'Setting'} {name} = {value}")
    if pretend:
        print("Command:", " ".join(cmd))
    else:
        subprocess.run(cmd, check=True)

def main():
    parser = get_argparse()
    args = parser.parse_args()

    
    author = scholarly.search_author_id(args.profile)
    author = scholarly.fill(author, sections=['basics', 'indices', 'coauthors'])

    gh_vars = {
        "CV_GSCHOLAR_CITATIONS": author.get('citedby', 0),
        "CV_GSCHOLAR_H_INDEX": author.get('hindex', 0),
        "CV_GSCHOLAR_I10_INDEX": author.get('i10index', 0),
        "CV_GSCHOLAR_ID": args.profile,
        "CV_LAST_UPDATED": datetime.now(timezone.utc).isoformat()

    }

    for name, value in gh_vars.items():
        set_gh_variable(name, value, repo=args.gh_repo, pretend=args.pretend)

if __name__ == "__main__":
    main()

