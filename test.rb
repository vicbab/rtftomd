require 'serrano'
require 'bibtex'

title = "Ecocentric and anthropocentric attitudes toward the environment"
author = "Thompson"
publication = "Journal of Environmental Psychology"
res = Serrano.works(query_container_title: "\"#{title}\"", query_author: author, query_bibliographic: publication, sort: 'relevance', order: "asc", format: "bibtex")
# res['message']['items'].collect { |x| x['author'][0]['family'] }
puts res['message']['items'].first
