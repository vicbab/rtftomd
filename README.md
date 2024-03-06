# What it is

RTFTOMD is a pre-CMS software used in conjunction with [Stylo](https://stylo.huma-num.fr), a Markdown CMS.

# What it does

1. Converts from RTF to MD with [Pandoc](https://github.com/jgm/pandoc)
2. Lints & formats the manuscript in preparation for use with [Stylo](https://stylo.huma-num.fr).
3. Parses the bibliography with [Anystyle](https://github.com/inukshuk/anystyle) and [Serrano](https://github.com/sckott/serrano).
4. Automatically adds the bibliography to a Zotero subcollection. (TODO: create a new subcollection for the article, properly formatted)
5. (TODO) Replaces inline/footnote citations with citation keys in the manuscript.
6. (TODO) Automatically adds the manuscript to [Stylo](https://github.com/EcrituresNumeriques/stylo)

Specifically made for [Lampadaire](lampadaire.ca). Planned to be made more flexible in the near future.

# How to use it

``Usage: app.rb [options]``

``"-f", "--file FILE", "File to parse"``

``"-b", "--bib FILE", "MD file to parse bibliography"``

``"-r", "--ref REF", "Reference to search"``

``"-l", "--lint FILE", "Lint the file"``
