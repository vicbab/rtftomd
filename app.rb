require 'optparse'
require 'serrano'
require 'bibtex'
require 'fileutils'

load 'tools/parse_bib.rb'
load 'tools/convert.rb'
load 'tools/populate_lib.rb'
load 'tools/populate_stylo.rb'

def run(options)
    #Populate.initialize()
    if options[:file].include? ".rtf"
        puts "Detected RTF file!"
        puts "Converting to MD..."
        Converter.convert(options)
        extension = ".md"
    end
    if options[:file].include? ".md"
        puts "Detected MD file!"
        puts "Linting..." #TODO: Add linting
        @file = options[:file]
        Converter.lint("#{@file}")
        extension = ""
    end

    if ! options[:skipbib]
        puts "Parsing bibliography..."
        BibParser.run("#{options[:file]}#{extension}")
    end

    #puts "Populating Zotero library..."
    #ZoteroCourier.populate_lib("#{options[:file]}#{extension}.bib")

    puts "Received ID : #{options[:id]}"

    if options[:id] != ""
        id = options[:id]
        puts "Populating Stylo with ID = #{options[:id]}"
        StyloCourier.populate("#{options[:file]}#{extension}", "#{options[:id]}")
    else
        puts "Populating Stylo without ID..."
        StyloCourier.populate("#{options[:file]}#{extension}", nil)
    end
    
    
    puts "Complete!"
end

def get_bib(file)
    return BibParser.run(file)
end

options = {}
OptionParser.new do |opts|
    opts.banner = "Usage: app.rb [options]"

    opts.on("-i", "--id ID", String, "Include article ID") do |id|
        options[:id] = id
    end
    
    opts.on("-s", "--skip-bib [FLAG]", "Skip bibliography") do |s|
        options[:skipbib] = s.nil? ? false : s
    end

    opts.on("-f", "--file FILE", "File to parse") do |file|
        options[:file] = file
        puts "RUNNING RTFTOMD: FILE PARSER"
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

    opts.on("-h", "--help", "Prints this help") do
        puts opts
        exit
      end
end.parse!

if options[:file] == nil
    puts "Error: No file specified"
    exit
else
    run(options)
end

# title = "force"
# author = "derrida"
# res = Serrano.works(query: title, query_author: author)
# # res['message']['items'].collect { |x| x['author'][0]['family'] }
# puts res['message']['items'].collect { |x| x['author'][0]['family'] }