#!/bin/bash

source ./build-settings-checks.sh

echo "Building LaTeX document"
latexmk -output-directory="./build" -pdf ${MAIN}.tex
