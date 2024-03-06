require 'serrano'
require 'bibtex'
require 'json'

# Serrano.configuration do |config|
#     config.mailto = "web@lampadaire.ca"
#   end

# title = "Ecocentric and anthropocentric attitudes toward the environment"
# author = "S. Thompson"
# publication = "Journal of Environmental Psychology"
# found_doi = Serrano.works(query: title, query_author: author, sort: 'relevance', order: "desc", format: 'bibtex')['message']['items'].first["DOI"]
# res = Serrano.content_negotiation(ids: found_doi, format: "bibtex")

# puts res

def populate_json(title, author)
    data = '{
        "itemType" : "book",
        "title" : "",
        "creators" : [
            {
                "creatorType" : "author",
                "firstName" : "",
                "lastName" : ""
            }
        ],
        "url" : "",
        "tags" : [],
        "collections" : [],
        "relations" : {}
    }'

    data_hash = JSON.parse(data)
    data_hash["title"] = title
    data_hash["creators"][0]["firstName"] = author.split(" ").first
    data_hash["creators"][0]["lastName"] = author.split(" ").last

    data_hash.to_json

    return data_hash
end

title = "Ecocentric and anthropocentric attitudes toward the environment"
author = "S. Thompson"

populated_data = populate_json(title, author)
puts populated_data

