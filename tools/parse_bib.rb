require 'anystyle'
require 'serrano'
require 'bibtex'

module BibParser
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
      meta_original = i
      puts "DOI: #{doi}"
      if doi
        begin
          puts "Extracting metadata..."
          meta_xref = Serrano.content_negotiation(ids: doi, format: "bibtex")
          puts meta_xref
          if meta_original.length < meta_xref.length
            new_bib += meta_xref
          else
            new_bib += "@#{meta_original}"
          end
        rescue => e
          puts "Error occurred while extracting metadata: #{e.message}"
          new_bib += "@#{i}"
        end
      else
        puts "No DOI found"
        new_bib += "@#{i}"
      end
    end

    puts "got here"

    new_bib = new_bib.gsub("@ @", "@")
    new_bib = new_bib.gsub(" @", "@")

    puts "got here"

    puts "Writing to #{fileToParse}.bib"

    File.open("#{fileToParse}.bib", "w") { |file| file.write(new_bib) }

    return new_bib
  end

  def format_keys(entry)
    #TODO
  end

  def find_doi(entry)
    doi = entry.match(/doi = \{(.+?)\}/)
    if doi
      doi = doi[1]
    else
      doi = nil
    end 
    return doi
  end

  def extract_metadata(doi)
    return Serrano.content_negotiation(ids: doi, format: "bibtex")
  end

  def configure_serrano
    Serrano.configuration do |config|
      config.mailto = "web@lampadaire.ca"
    end
  end

  def run(file)
    configure_serrano
    bib = parse(file)
  end

  module_function :parse, :format_keys, :find_doi, :extract_metadata, :configure_serrano, :run
end