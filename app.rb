require 'optparse'

load 'tools/parse_bib.rb'
load 'tools/convert.rb'

def run(options)
    Converter.convert(options)
    BibParser.run("#{options[:file]}.md")
end


def initialize()
    options = {}
    OptionParser.new do |opts|
        opts.banner = "Usage: app.rb [options]"

        opts.on("-f", "--file FILE", "File to parse") do |file|
            options[:file] = file
        end
    end.parse!

    if options[:file] == nil
        puts "Error: No file specified"
        exit
    end

    return options
end

run(initialize())
