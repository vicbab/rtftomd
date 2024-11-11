text = "@article{jaggar1989a,
  author = {Jaggar, Allison M.},
  date = {1989},
  title = {Love and knowledge Emotion in feminist epistemology},
  volume = {32},
  pages = {151–176},
  note = {DOI: [http://dx.doi.org/10.1080/00201748908602185](http://dx.doi.org/10.1080/00201748908602185},
  journal = {Inquiry An Interdisciplinary Journal of Philosophy},
  number = {2}
}"

text_nokey = "@book{
  title = {The Rust Programming Language (Covers Rust 2018)},
  author = {Steve Klabnik, Carol Nichols},
  publisher = {No Starch Press},
  year = {2019-09-03},
  doi = {9781718500457},
  url = {http://books.google.ca/books?id=qAOhDwAAQBAJ&dq=,+,+,&hl=&source=gbs_api}
}"

def find_type(entry)
  key = entry.match(/@(.+?)\{(.+?),/)
  if key
    key = key[1]
  else
    key = "document"
  end
  return key
end

def find_key(entry)
    key = entry.match(/@(.+?)\{(.+?),/)
    if key
      key = key[2]
    else
      key = "placeholder"
    end
    return key
end

def find_title(entry)
    title = entry.match(/title = \{(.+?)\}/)
    if title
      title = title[1]
    else
      title = ""
    end
    return title
  end

def find_author(entry)
    author = entry.match(/author = \{(.+?)\}/)
    if author
        author = author[1]
    else
        author = ""
    end
    return author
end

def find_year(entry)
    year = entry.match(/year = \{(.+?)\}/)
    if year
        year = year[1]
    else
        year = entry.match(/date = \{(.+?)\}/)[1]
    end
    return year
end

def format_key(entry)
    author = find_author(entry).match(/([A-Z])\w+/)[0]
    title = find_title(entry).match(/([A-Z])\w+/)[0]
    year = find_year(entry)

    key = "#{author}_#{title}_#{year}".downcase

    return key
end

def test_key(entry)
    expected = find_key(entry)
    got = format_key(entry)
    return expected == got
end
puts test_key(text)
