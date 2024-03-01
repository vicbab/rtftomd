require 'optparse'
require 'open3'
require 'fileutils'

module Converter
    def convert(options)
        @file = options[:file]
        stdout, stderr, status = Open3.capture3("pandoc --from=rtf --to=markdown --output=#{options[:file]}.md < #{@file}")

        if status.success?
            lint("#{@file}.md")
        else
            puts "Conversion failed: #{stderr}"
            exit
        end
    end

    def lint(file)
        puts file
        FileUtils.cp("#{file}", "#{file}_copie.md")

        begin
            contents = File.read("#{file}")

            
            contents = format(contents)

            File.open("#{file}", 'w') do |file|
                file.write(contents)
            end

            puts "Done replacing #{file}"
        rescue => e
            puts "An error occurred: #{e}"
            exit
        end
    end

    def replace_wrong_quotes(match)
        inner_text = match[1]
        inner_text = inner_text.gsub('«', '"').gsub('»', '"')
        return '«' + "&nbsp;" + inner_text + "&nbsp;" + '»'
    end

    def replace_quotes(match)
        inner_text = match[1]
        if inner_text.length >= 500
            return "\n> " + inner_text.gsub('\n', '\n> ') + "\n"
        else
            return match[0]
        end
    end

    def format(contents)
        contents = contents.gsub("\\", "")
        contents = contents.gsub("[^", "&sticker&")
        contents = contents.gsub("^", "")
        contents = contents.gsub("&sticker&", " [^")
        contents = contents.gsub("’", "\'")
        contents = contents.gsub("[...", "[...]")
        contents = contents.gsub(/. \* /, '*')
        # contents = contents.gsub("« ", "«&nbsp;")
        # contents = contents.gsub(" »", "&nbsp;»")
        contents = contents.gsub("« ", "«&nbsp;")
        contents = contents.gsub(" »", "&nbsp;»")
        contents = contents.gsub(" ", "&nbsp;")

        # Merging broken lines
        contents = contents.gsub(/(?<!\n)\n(?!\n)/, ' ')

        contents = contents.gsub(/\n\*(.*?)\*\n/) do |match|
            "\n## #{$1}\n"
        end

        # Formatting quotes TODO
        #contents = contents.gsub(/«(.*?)»/) { |match| replace_wrong_quotes(match) }
        #contents = contents.gsub(/«([\s\S]*?)»/) { |match| replace_quotes(match) }

        return contents
    end
    module_function :convert, :replace_wrong_quotes, :replace_quotes, :format, :lint
end

# # Create the parser
# options = {}
# OptionParser.new do |opts|
#     opts.banner = "Usage: app.rb [options]"

#     opts.on("-f", "--file FILE", "Path to the file") do |file|
#         options[:file] = file
#     end
# end.parse!

# # Convert RTF to Markdown
# stdout, stderr, status = Open3.capture3("pandoc --from=rtf --to=markdown --output=#{options[:file]}.md < #{options[:file]}")

# # Check if the conversion was successful
# if status.success?
#     puts "Converted #{options[:file]} to #{options[:file]}.md"

#     # Save a copy of the original file
#     FileUtils.cp("#{options[:file]}.md", "#{options[:file]}_copie.md")

#     # Open the file
#     begin
#         contents = File.read("#{options[:file]}.md", encoding: "latin-1")

#         # Replace the text

#         def replace_wrong_quotes(match)
#             inner_text = match[1]
#             inner_text = inner_text.gsub('«', '"').gsub('»', '"')
#             "«" + inner_text + "»"
#         end

#         # Replace the matched text

#         def replace_quotes(match)
#             inner_text = match[1]
#             if inner_text.length >= 500
#                 "\n> " + inner_text.gsub("\n", "\n> ") + "\n"
#             else
#                 match[0]
#             end
#         end

#         # Replacing odd characters
#         contents = contents.gsub("\\", "")
#         contents = contents.gsub("[^", "&sticker&")
#         contents = contents.gsub("^", "")
#         contents = contents.gsub("&sticker&", " [^")
#         contents = contents.gsub("’", "\'")
#         contents = contents.gsub("[...", "[...]")
#         contents = contents.gsub(/. \* /, '*')

#         # Merging broken lines
#         contents = contents.gsub(/(?<!\n)\n(?!\n)/, ' ')

#         # Formatting quotes
#         contents = contents.gsub(/«(.*?)»/m, &method(:replace_wrong_quotes))
#         contents = contents.gsub(/«([\s\S]*?)»/m, &method(:replace_quotes))

#         # Write the result back to the file
#         File.open("#{options[:file]}.md", 'w', encoding: "latin-1") do |file|
#             file.write(contents)
#         end

#         # Print the result
#         puts "Done replacing #{options[:file]}.md"
#     rescue => e
#         puts "An error occurred: #{e}"
#         exit
#     end
# else
#     puts "Conversion failed: #{stderr}"
#     exit
# end

# def replace_wrong_quotes(match)
#     inner_text = match[1]
#     inner_text = inner_text.gsub('«', '"').gsub('»', '"')
#     return '«' + inner_text + '»'
# end

# def replace_quotes(match)
#     inner_text = match[1]
#     if inner_text.length >= 500
#         return "\n> " + inner_text.gsub('\n', '\n> ') + "\n"
#     else
#         return match[0]
#     end
# end


# def replace_odds(contents)
#     contents = contents.gsub("\\", "")
#     contents = contents.gsub("[^", "&sticker&")
#     contents = contents.gsub("^", "")
#     contents = contents.gsub("&sticker&", " [^")
#     contents = contents.gsub("’", "\'")
#     contents = contents.gsub("[...", "[...]")
#     contents = contents.gsub(/. \* /, '*')

#     # Merging broken lines
#     contents = contents.gsub(/(?<!\n)\n(?!\n)/, ' ')

#     # Formatting quotes
#     contents = contents.gsub(/«(.*?)»/) { |match| replace_wrong_quotes(match) }
#     contents = contents.gsub(/«([\s\S]*?)»/) { |match| replace_quotes(match) }

#     return contents
# end