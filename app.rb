require 'optparse'
require 'serrano'
require 'bibtex'
require 'fileutils'

load 'tools/parse_bib.rb'
load 'tools/convert.rb'
load 'tools/populate_lib.rb'

def run(options)
    #Populate.initialize()
    Converter.convert(options)
    BibParser.run("#{options[:file]}.md")
    ZoteroCourier.populate_lib("#{options[:file]}.md.bib")
end

def get_bib(file)
    return BibParser.run(file)
end

options = {}
OptionParser.new do |opts|
    opts.banner = "Usage: app.rb [options]"

    opts.on("-f", "--file FILE", "File to parse") do |file|
        options[:file] = file
        run(options)
    end
    opts.on("-b", "--bib FILE", "MD file to parse bibliography") do |file|
        options[:file] = file
        get_bib(file)
    end
    opts.on("-r", "--ref REF", "Reference to search") do |ref|
        options[:ref] = ref
        puts BibParser.get_ref(ref)
    end
    opts.on("-l", "--lint FILE", "Lint the file") do |file|
        options[:file] = file
        Converter.lint(options[:file])
        puts "Linting complete"
    end
end.parse!

if options[:file] == nil
    puts "Error: No file specified"
    exit
end

# title = "force"
# author = "derrida"
# res = Serrano.works(query: title, query_author: author)
# # res['message']['items'].collect { |x| x['author'][0]['family'] }
# puts res['message']['items'].collect { |x| x['author'][0]['family'] }