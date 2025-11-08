# ESV Verse CLI

A CLI tool to get ESV verses.

## API Token

Get your API token from https://api.esv.org/ \
Follow the documentation instructions, and inside `.bible-config`, assign
`ESV_API_TOKEN` to your given API token.\
Keep this private.

## Usage

You can pass in arguments inside quotes after the `verse` command.\
Examples:

- `verse "John 3:16"`
- `verse "John 3:16-17"`
- `verse "John 3:16,17"`
- `verse "John 3:16-17; Matthew 28:18-20"`

You can also pipe verses separated by a newline into `verse`.\
Examples:

- `cat verses.txt | verse`
- `echo "John 3:16" | verse`

## Configuration

On the first time running, it will generate a `.bible-config`.\
All configs are optional EXCEPT for ESV_API_TOKEN, which needs to be filled out
for the program to work.\
Edit the config's options to your liking, for example, `INCLUDE_VERSE_NUMBERS=true`.
