require 'zotero'
# require 'active_support/core_ext/numeric/time'
# require 'active_support/core_ext/string/inflections'
require 'restclient/components'
require 'rack/cache'  
require 'dotenv/load'

load 'tools/zotero/zotero_api.rb'

def run 
    unless ENV['ZOTERO_USER_ID'] && ENV['ZOTERO_API_KEY']
      raise 'Env vars ZOTERO_USER_ID and ZOTERO_API_KEY must be set'
    end

    data ='[
        {
          "name" : "TEST-RTFTOMD",
          "parentCollection" : "LYNVDVRP"
        }
      ]'

    RestClient.enable Rack::Cache
    # @library = ::Zotero::Library.new ENV['ZOTERO_USER_ID'], ENV['ZOTERO_API_KEY']
    # collection = @library.collections.first 
    # collection.entries.first.title

    ZoteroApi.new(ENV['ZOTERO_USER_ID'], ENV['ZOTERO_API_KEY'], ENV['ZOTERO_GROUP_ID']).create_collection(data)
    
end

run