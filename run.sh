#!/bin/bash

python app.py "$1"

ruby parse_bib.rb "$1.md"