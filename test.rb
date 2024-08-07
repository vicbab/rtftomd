require 'serrano'
require 'bibtex'
require 'json'
require 'GoogleBooks'

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

title = "A theory of justice"
author = ""

# populated_data = populate_json(title, author)
# puts populated_data

books = GoogleBooks.search("#{title}, #{author}")

books.each do |book|
    puts book.title
    puts book.authors
    puts book.published_date
    puts book.publisher
    puts book.description
    puts book.isbn
    puts "----------------"
end
# book = books.first

# i = 0

# while i < 10
#     puts books[i].title
#     puts books[i].authors
#     puts books[i].title
#     puts books[i].published_date
#     puts books[i].publisher
#     # puts books[i].description
#     puts books[i].isbn
#     i += 1
# end


