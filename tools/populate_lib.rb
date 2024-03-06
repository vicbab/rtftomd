require 'zotero'
# require 'active_support/core_ext/numeric/time'
# require 'active_support/core_ext/string/inflections'
require 'restclient/components'
require 'rack/cache'  
require 'dotenv/load'
require 'bibtex'

load 'tools/zotero/zotero_api.rb'

module ZoteroCourier
  def populate_lib(file)
    add_items(file)
  end

def convert_to_json(file)
  bib = BibTeX.open(file)
  data = []
  for i in bib
    data.push(populate_json(i.to_citeproc.to_json['title'], i.to_citeproc.to_json['author'], i.to_citeproc.to_json))
  end
  puts data
  return data
end

def populate_json(info)
  # data = '{
  #     "itemType" : "book",
  #     "title" : "",
  #     "creators" : [
  #         {
  #             "creatorType" : "author",
  #             "firstName" : "",
  #             "lastName" : ""
  #         }
  #     ],
  #     "url" : "",
  #     "tags" : [],
  #     "collections" : [],
  #     "relations" : {}
  # }'

  data = ZoteroApi.new(ENV['ZOTERO_USER_ID'], ENV['ZOTERO_API_KEY'], ENV['ZOTERO_GROUP_ID']).get_template('journalArticle').to_json

  data_hash = JSON.parse(data)
  info_hash = JSON.parse(info)
  puts info_hash.to_json
  # data_hash["title"] = title
  # data_hash["creators"][0]["firstName"] = author.first
  # data_hash["creators"][0]["lastName"] = author.last
  new_hash = {
    "itemType": "journalArticle",
    "title": info_hash['title'],
    "creators": [
        {
            "creatorType": "author",
            "firstName": info_hash['author'][0]['given'],
            "lastName": info_hash['author'][0]['family']
        }
    ],
    "publicationTitle": info_hash['container-title'],
    "volume": info_hash['volume'],
    "issue": info_hash['issue'],
    "pages": info_hash['page'],
    "date": info_hash['issued']['date-parts'][0].first.to_s, #TODO
    "DOI": info_hash['DOI'],
    "ISSN": info_hash['issn'],
    "url": info_hash['URL'],
    "tags": [],
    "collections": ["74FCTFRR"],
    "relations": {}
  }

  #puts info_hash.select { |k| data_hash.keys.include? k }.to_json
  #data_hash.merge info_hash.select { |k| data_hash.keys.include? k }
  puts "new_hash: " + new_hash.to_json + "\n"
  
  data_hash = new_hash.merge data_hash.select { |k| data_hash.keys.include? k }


  return [new_hash]
end

def add_items(file) 
    unless ENV['ZOTERO_USER_ID'] && ENV['ZOTERO_API_KEY']
      raise 'Env vars ZOTERO_USER_ID and ZOTERO_API_KEY must be set'
    end
    RestClient.enable Rack::Cache

    bib = BibTeX.open(file)
    data = ""
    for i in bib
      data = populate_json(i.to_citeproc.to_json).to_json
      puts "sending " + data
      ZoteroApi.new(ENV['ZOTERO_USER_ID'], ENV['ZOTERO_API_KEY'], ENV['ZOTERO_GROUP_ID']).create_item(data)
    end
    

    # @library = ::Zotero::Library.new ENV['ZOTERO_USER_ID'], ENV['ZOTERO_API_KEY']
    # collection = @library.collections.first 
    # collection.entries.first.title

    # ZoteroApi.new(ENV['ZOTERO_USER_ID'], ENV['ZOTERO_API_KEY'], ENV['ZOTERO_GROUP_ID']).create_collection(data)

    

  end
  module_function :populate_lib, :convert_to_json, :populate_json, :add_items

end

