require 'anystyle'

refs = AnyStyle.find ARGV[0]

puts refs.to_s

bib = AnyStyle.parse refs.to_s.split("\","), format: 'bibtex'

File.write("#{ARGV[0]}.bib", bib.to_s)