#!/bin/bash
pandoc --filter pandoc-citeproc --bibliography=./docs/library.bib --variable papersize=a4paper -s Readme.md -o Readme.pdf
pandoc --filter pandoc-citeproc --bibliography=./docs/library.bib --variable papersize=a4paper -s Readme.md -o Readme.tex