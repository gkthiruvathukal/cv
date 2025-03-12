#!/usr/bin/env python

import os
import re
from jinja2 import Template

DATA_DIR = "./data"

# Discover and sort .tex files by numeric prefix
sections = sorted(
    [os.path.join(DATA_DIR, f) for f in os.listdir(DATA_DIR) if f.endswith(".tex")],
    key=lambda x: int(os.path.basename(x).split("-")[0])  # Extract numeric prefix
)

# Classify sections using regex
header_sections = [s for s in sections if re.match(r"0\d-", os.path.basename(s))]
main_sections = [s for s in sections if re.match(r"[1-9]\d-", os.path.basename(s))]

# Load LaTeX template
with open("cv-template.tex") as f:
    template = Template(f.read())

# Render LaTeX document
latex_source = template.render(
    header_sections=header_sections, 
    main_sections=main_sections
)

# Write output
with open("cv-main.tex", "w") as f:
    f.write(latex_source)

print("Generated cv-main.tex successfully!")
