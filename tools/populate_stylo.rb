#TODO: create stylo articles from converted ... with link to bib
load 'tools/stylo/stylo_api.rb'
load 'tools/parse_bib.rb'


module StyloCourier
    def populate(file, id)
        metadata = GenerateMetadata.parse(file, id)
        create_article(metadata[0], metadata[1], metadata[2], metadata[3])
    end

    def create_article(title, md, bib, yaml)
        StyloApi::Client.query(Articles::Create, variables: {"title": title, "content": {  "bib": bib, "md": md, "yaml": yaml}})
        puts "Article created"
       end
     
    def get_articles
        StyloApi::Client.query(Articles::GetArticles)
    end
    
    module_function :populate, :create_article, :get_articles
     
end

module GenerateMetadata
    def parse(file, id)
        version = ""
        content = File.read(file)
        bib = File.read("#{file}.bib")
        #title = get_title(content)
        title = ""
        puts "No ID: #{id.nil?}"
        if id.nil?
            id = "XXXX"
            title = get_title(content)
        else
            title = id
        end
        md = content
        yaml = "---\narticleslies:\n  - auteur: ''\n    title: #{title}\n    url: https://lampadaire.ca/articles/#{id}.html\ndirector:\n  - foaf: ''\n    forname: ''\n    gender: ''\n    isni: ''\n    orcid: ''\n    surname: ''\n    viaf: ''\ndossier:\n  - id: ''\n    title: ''\n    title_f: ''\nid: #{id}\nlang: fr\nlink-citations: true\nrights: Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)\ntitle: untitled\ntitle_f: untitled\ntranslations:\n  - lang: ''\n    title: ''\n    url: ''\ntranslator:\n  - forname: ''\n    surname: ''\nnocite: '@*'\nurl_article: articles/#{id}.html\n---"
        
        puts "Parsed metadata"

        return [id, md, bib, yaml]
    end

    def get_title(content)
        title = content.match(/title: (.+?)\n/)
        if title
            title = title[1]
        else
            title = "Untitled"
        end
    end

    module_function :parse, :get_title
end