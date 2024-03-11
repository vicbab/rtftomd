require "graphql/client"
require "graphql/client/http"
require 'dotenv/load'

# Stylo API example wrapper
module StyloApi
    # Configure GraphQL endpoint using the basic HTTP network adapter.
    HTTP = GraphQL::Client::HTTP.new("https://stylo.huma-num.fr/graphql") do
      def headers(context)
        # Optionally set any HTTP headers
        { "content-type": "application/json", "Authorization": "Bearer #{ENV['STYLO_API_KEY']}" }
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

    GetArticles = StyloApi::Client.parse <<-'GRAPHQL'
      query {
        articles {
          _id
          title
          contributors {
            user {
              displayName
            }
          }
          workingVersion {
            md
            yaml
            bib
          }
          versions {
            _id
          }
          tags {
            name
          }
        }
      }
    GRAPHQL


    GetArticle = StyloApi::Client.parse <<-'GRAPHQL'
      query ($article: ID!){
        article(article: $article) {
          _id
          title
          contributors {
            user {
              displayName
            }
          }
          workingVersion {
            md
            yaml
            bib
          }
          versions {
            _id
          }
        }
      }
    GRAPHQL

    title = "default"



    ContentFragment = StyloApi::Client.parse <<-'GRAPHQL'
      fragment content on Article {
        updateWorkingVersion(content: $content) {
          workingVersion {
            md
          }
        }
      }
    GRAPHQL

    # Ne pas oublier: variable zoteroLink possible! createArticle(title: "string", user: "_____", tags: ["_____"])
    Create = StyloApi::Client.parse <<-'GRAPHQL'
    mutation($title: String!) {
        createArticle(
            title: $title,
            user: "5f3e3e3e3e3e3e3e3e3e3e3e"
        ) {
            title
            _id

            workingVersion {
              bib
              md
              yaml

            }

            ...ContentFragment
        }

    }
    GRAPHQL

    # Populate = StyloApi::Client.parse <<-'GRAPHQL'
    # mutation updateWorkingVersion(content: {}) {
    #   _id
    #   title
    #   setZoteroLink(zotero: "string")
    #   updateWorkingVersion(content: {}) {
    #     _id
    #     title
    #     zoteroLink
    #     workingVersion
    #   }
    # }
    # GRAPHQL
end

def create_article(title, md = "Testing")
    StyloApi::Client.query(Articles::Create, variables: { title: title})
end

articlesdata = StyloApi::Client.query(Articles::GetArticles).data.articles

results = StyloApi::Client.query(Articles::GetArticle, variables: { article: "65457bd72b40d5001250a550" }).data.article.working_version.md

ContentFragment = Articles::ContentFragment(variables: {content: "{md: \"Test-API\"}"})

puts StyloApi::Client.query(Articles::Create, variables: { title: "Testing-10"})

# for article in articlesdata
#   # puts article.working_version.md
#   # puts article.myid
# end
#
# puts results
# create_article("test-API")
