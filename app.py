import os
import argparse
import re
import shutil

# Create the parser
parser = argparse.ArgumentParser(description="Process a file.")

# Add the arguments
parser.add_argument('FilePath', metavar='path', type=str, help='the path to the file')

# Parse the arguments
args = parser.parse_args()

# Convert RTF to Markdown
os.system(f"pandoc --from=rtf --to=markdown --output={args.FilePath}.md < {args.FilePath}")

# Print the result

print(f"Converted {args.FilePath} to {args.FilePath}.md")

# Save a copy of the original file
shutil.copyfile(f'{args.FilePath}.md', f'{args.FilePath}_copie.md')

# Open the file
with open(f'{args.FilePath}.md', 'r', encoding="latin-1") as file:
    # Read the file
    try:
        contents = file.read()
    except Exception as e:
        print(f"An error occurred: {e}")
        exit()

# Replace the text

def replace_wrong_quotes(match):
    inner_text = match.group(1)
    inner_text = inner_text.replace('«', '"').replace('»', '"')
    return '«' + inner_text + '»'

# Replace the matched text

def replace_quotes(match):
    inner_text = match.group(1)
    if len(inner_text) >= 500:
        return '\n> ' + inner_text.replace('\n', '\n> ') + '\n'
    else:
        return match.group(0)
    # # The regular expression pattern
    # pattern = r'«([\s\S]*?)»'

    # # Find all occurrences of the pattern
    # matches = re.findall(pattern, text, re.DOTALL)

    # # Filter matches that are less than 500 characters long
    # matches = [match for match in matches if len(match) >= 500]

    # # Format the matches as Markdown blockquotes
    # markdown_citations = ['> ' + match.replace('\n', '\n> ') for match in matches]

    # # Replace the citations


    # # Print the Markdown-formatted citations
    # for citation in markdown_citations:
    #     print(citation)
    #     #replace the matches
    #     text = text.replace('«' + citation + '»', citation)
    # return text

def replace_quotes2(text):
    pattern = r'«*?.»'

    # Find all occurrences of the pattern
    matches = re.findall(pattern, text, re.DOTALL)
    print(matches)

    # Filter matches that are less than 500 characters long
    matches = [match for match in matches if len(match) >= 500]

    # Replace the matches
    for match in matches:
        # Remove the quotes
        inner_text = match.replace('«', '>').replace('»', '')
        text = text.replace(match, inner_text)
    print(text)
    return text



# Replacing odd characters
contents = contents.replace("\\", "")
contents = contents.replace("[^", "&sticker&")
contents = contents.replace("^", "")
contents = contents.replace("&sticker&", " [^")
contents = contents.replace("’", "\'")
contents = contents.replace("[...", "[...]")
contents = re.sub(r'. \* ', '*', contents)

# Merging broken lines
contents = re.sub('(?<!\n)\n(?!\n)', ' ', contents)

# Formatting quotes
contents = re.sub(r'«(.*?)»', replace_wrong_quotes, contents, flags=re.DOTALL)
contents = re.sub(r'«([\s\S]*?)»', replace_quotes, contents, flags=re.DOTALL)

# Write the result back to the file
with open(f'{args.FilePath}.md', 'w', errors='ignore') as file:
    file.write(contents)

# Close the file
file.close()

# Print the result
print(f"Done replacing {args.FilePath}.md")