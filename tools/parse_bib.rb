require 'anystyle'
require 'serrano'
require 'bibtex'

module BibParser
  def get_ref(ref)
    return AnyStyle.parse ref, format: 'bibtex'
  end

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
      title = find_title(i)
      author = find_author(i)
      meta_original = i.force_encoding('UTF-8')
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
        puts "Trying to fetch metadata..."
        #todo
        # meta_xref = Serrano.works(query_container_title: title, query_author: author, sort: 'relevance', order: "asc", format: "bibtex")['message']['items'].first
        # puts "Got metadata: #{meta_xref}"
        # puts "Was: #{meta_original}"

        # unless meta_xref.length < meta_original.length
        #   new_bib += meta_xref
        # else
        #   new_bib += meta_original
        # end
        puts "skipping"
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

  def find_title(entry)
    title = entry.match(/title = \{(.+?)\}/)
    if title
      title = title[1]
    else
      title = nil
    end
    return title
  end

  def find_author(entry)
    author = entry.match(/author = \{(.+?)\}/)
    if author
      author = author[1]
    else
      author = nil
    end
    return author
  end

  def extract_from_doi(doi)
    return Serrano.content_negotiation(ids: doi, format: "bibtex")
  end

  def configure_serrano
    Serrano.configuration do |config|
      config.mailto = "web@lampadaire.ca"
    end
  end

  def run(file)
    configure_serrano
    # title = "force de loi"
    # author = "jacques derrida"
    # puts Serrano.works(query: ".bibliographic=#{title}&query.author=#{author}", format: "bibtex")
    bib = parse(file)
  end

  module_function :parse, :format_keys, :find_doi, :extract_from_doi, :configure_serrano, :run, :find_title, :find_author, :get_ref
end