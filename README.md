# ESV Verse CLI

A Bash CLI for fetching ESV Bible passages from the terminal.

## Requirements

- `curl`
- `jq`

## Setup

1. Clone the repo and make the script executable:

   ```bash
   git clone <repo-url>
   cd esv-cli
   chmod +x verse
   ```

2. Copy the example config and add your API token:

   ```bash
   cp .env.example .env
   ```

3. Get an API token from [https://api.esv.org/account/create-application/](https://api.esv.org/account/create-application/) and set it in `.env`:
   ```
   ESV_API_TOKEN="your-token-here"
   ```

## Usage

```bash
./verse "John 3:16"
./verse "John 3:16-17"
./verse "John 3:16-17; Matthew 28:18-20"  # multiple passages
echo "John 3:16" | ./verse                 # piped input
cat verses.txt | ./verse                   # one reference per line
```

**Options:**

| Flag | Description              |
| ---- | ------------------------ |
| `-h` | Show help                |
| `-c` | Show config file path    |
| `-e` | Open config in `$EDITOR` |

## Configuration

All options in `.env` are optional except `ESV_API_TOKEN`. See `.env.example` for the full list with descriptions.

Common options:

| Variable                     | Default | Description                                |
| ---------------------------- | ------- | ------------------------------------------ |
| `INCLUDE_PASSAGE_REFERENCES` | `true`  | Show the passage reference before the text |
| `INCLUDE_VERSE_NUMBERS`      | `true`  | Show verse numbers inline                  |
| `INCLUDE_HEADINGS`           | `true`  | Show section headings                      |
| `INCLUDE_FOOTNOTES`          | `true`  | Show footnote callouts                     |
| `INCLUDE_FOOTNOTE_BODY`      | `true`  | Show footnote text below passage           |
| `INCLUDE_SHORT_COPYRIGHT`    | `true`  | Append "(ESV)" to the text                 |
| `LINE_LENGTH`                | `0`     | Wrap lines at this width (`0` = unlimited) |
