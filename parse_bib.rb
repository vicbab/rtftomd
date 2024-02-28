require 'anystyle'
require 'serrano'


def parse(fileToParse)
  file = File.open(fileToParse, "r")

  #Make a copy
  file_copy = File.open("#{fileToParse}.txt", "w")

  content = file.read.encode('UTF-8', :invalid => :replace, :undef => :replace, :replace => '')
  content = content.gsub("*", "")
  content = content.gsub(">", "")
  content = content.gsub(/\[\^\d+\]:\s+.*/, "")

  file_copy.write(content)
  file_copy.close
  file.close

		
  refs = AnyStyle.find file_copy.path

  bib = AnyStyle.parse refs.to_s.split("\","), format: 'bibtex'

  bib = bib.to_s.gsub("[\"", "")

  bib = bib.split("@")

  new_bib = ""

  for i in bib
    doi = find_doi(i)
    if doi != nil
      meta_original = i
      meta_xref = extract_metadata(doi)
      if meta_original.length < meta_xref.length
        new_bib += meta_xref
      else
        new_bib += "@#{meta_original}"
      end
    else
      new_bib += "@#{i}"
    end
  end

  new_bib = new_bib.gsub("@ @", "@")
  new_bib = new_bib.gsub(" @", "@")

  puts "Writing to #{fileToParse}.bib"

  File.write("#{fileToParse}.bib", new_bib)

  return new_bib
end

def format_keys(entry)
  #TODO
end

def find_doi(entry)
  doi = entry.match(/doi = \{(.+?)\}/)
  if doi
    puts doi[1]
    extract_metadata(doi[1])
    return doi[1]
  else
    puts "DOI not found"
    return nil
  end
  
end

def extract_metadata(doi)
  # RestClient.get("https://api.crossref.org/works/#{doi}", headers={"User-Agent : Lampadaire/1.0 (https://lampadaire.ca/; mailto:web@lampadaire.ca)"})

  # metadata = RestClient.post(url, payload, headers={})
  
  #metadata = Serrano.works(ids: doi)

  metadata = Serrano.content_negotiation(ids: doi, format: "bibtex")
  puts metadata
  return metadata
end

def run
  while ARGV.length < 1
      puts "Please provide a file to parse"
      exit
  end

  i = 0

  while i < ARGV.length
      bib = parse(ARGV[i])

      i += 1
  end
end

def configure_serrano
  Serrano.configuration do |config|
    config.mailto = "web@lampadaire.ca"
  end
end

configure_serrano
run