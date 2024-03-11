#TODO: create stylo articles from converted ... with link to bib
load 'tools/stylo/stylo_api.rb'
load 'tools/parse_bib.rb'


module StyloCourier
    def populate(file)
        metadata = GenerateMetadata.parse(file)
        create_article(metadata[0], metadata[1], metadata[2], metadata[3])
    end

    def create_article(title, md, bib, yaml)
        StyloApi::Client.query(Articles::Create, variables: {"title": title, "content": {  "bib": bib, "md": md, "yaml": yaml}})
       end
     
    def get_articles
        StyloApi::Client.query(Articles::GetArticles)
    end
    
    module_function :populate, :create_article, :get_articles
     
end

module GenerateMetadata
    def parse(file)
        content = File.read(file)
        bib = File.read("#{file}.bib")
        title = get_title(content)
        md = content
        yaml = "---
        bibliography: ''
        title: ''
        title_f: ''
        surtitle: ''
        subtitle: ''
        subtitle_f: ''
        year: ''
        month: ''
        day: ''
        date: ''
        url_article_sp: ''
        publisher: ''
        prod: ''
        funder_name: ''
        funder_id: ''
        prodnum: ''
        diffnum: ''
        rights: >-
          Creative Commons Attribution-ShareAlike 4.0 International (CC
          BY-SA 4.0)
        issnnum: ''
        journal: ''
        journalsubtitle: ''
        journalid: ''
        director:
          - forname: ''
            surname: ''
            gender: ''
            orcid: ''
            viaf: ''
            foaf: ''
            isni: ''
        abstract: []
        translatedTitle: []
        authors: []
        dossier:
          - title_f: ''
            id: ''
        redacteurDossier: []
        typeArticle: []
        translator:
          - forname: ''
            surname: ''
        lang: fr
        orig_lang: ''
        translations:
          - lang: ''
            title: ''
            url: ''
        articleslies:
          - url: ''
            title: ''
            auteur: ''
        reviewers: []
        keyword_fr_f: ''
        keyword_en_f: ''
        keyword_fr: ''
        keyword_en: ''
        controlledKeywords: []
        link-citations: true
        nocite: '@*'
        issueid: ''
        ordseq: ''
        ---"
        
        return [title, md, bib, yaml]
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