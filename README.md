# What it does

Converts from RTF to MD with [Pandoc](https://github.com/jgm/pandoc), then RegEx cleanup in preparation for use with [Stylo](https://stylo.huma-num.fr).

Then, another program can extract the bibliography (using [Anystyle](https://github.com/inukshuk/anystyle)), which is then enhanced by recuperating the correct metadata from Crossref. Outputs a BibTeX file (.bib). 

Specifically made for [Lampadaire](lampadaire.ca). Planned to be made more flexible in the near future.

# How to use it
``python app.py path-to-file.rtf``
