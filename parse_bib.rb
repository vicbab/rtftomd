require 'anystyle'

file = File.open(ARGV[0], "r")

#Make a copy
file_copy = File.open("#{ARGV[0]}.txt", "w")

content = file.read.encode('UTF-8', :invalid => :replace, :undef => :replace, :replace => '')
content = content.gsub("*", "")
content = content.gsub(">", "")
content = content.gsub(/\[\^\d+\]:\s+.*/, "")

puts content

file_copy.write(content)
file_copy.close
file.close

refs = AnyStyle.find file_copy.path

bib = AnyStyle.parse refs.to_s.split("\","), format: 'bibtex'

puts "Writing to #{ARGV[0]}.bib"

File.write("#{ARGV[0]}.bib", bib.to_s)