require "graphql/client"
require "graphql/client/http"
require 'dotenv/load'

# Stylo API example wrapper
module StyloApi
    # Configure GraphQL endpoint using the basic HTTP network adapter.
    HTTP = GraphQL::Client::HTTP.new("https://stylo.huma-num.fr/graphql") do
      def headers(context)
        # Optionally set any HTTP headers
        { "content-type": "application/json", "Authorization": "Bearer #{ENV['STYLO_API_KEY']}"}
      end
    end  
  
    # Fetch latest schema on init, this will make a network request
    Schema = GraphQL::Client.load_schema(HTTP)
  
    # However, it's smart to dump this to a JSON file and load from disk
    #
    # Run it from a script or rake task
    #GraphQL::Client.dump_schema(StyloApi::HTTP, "schemas/schema.json")
    # GraphQL::Client.dump_schema(StyloApi::HTTP, "schemas/listArticles.json")
    #
    #Schema = GraphQL::Client.load_schema("schemas/listArticles.json")
  
    #puts GraphQL::Client.dump_schema(StyloApi::HTTP).inspect
    Client = GraphQL::Client.new(schema: Schema, execute: HTTP)
end


module Articles
    ListAll = StyloApi::Client.parse <<-'GRAPHQL'
        query   {
            user {
                _id
                email
     
                articles {
                    _id
                    title
                }
            }
        }
    GRAPHQL

    title = "default"

    # Ne pas oublier: variable zoteroLink possible! createArticle(title: "string", user: "_____", tags: ["_____"])
    Create = StyloApi::Client.parse <<-'GRAPHQL'
    mutation($title: String!, $md: String!) {
        createArticle(
            title: $title,
            user: "5f3e3e3e3e3e3e3e3e3e3e3e",
            md: $md
        ) {
            title
            _id

            workingVersion {
            bib
            md
          }
        }
        
    }
    GRAPHQL
end

def create_article(title, md = "Testing")
    StyloApi::Client.query(Articles::Create, variables: { title: title, md: md })
end

# results = StyloApi::Client.query(Articles::ListAll)

# for article in results.data.user.articles
#     puts article.title
# end

create_article("test-API")