#!/bin/bash

source ./build-settings.sh

echo "Building LaTeX document"
latexmk -output-directory="./build" -pdf ${MAIN}.tex
