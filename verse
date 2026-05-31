#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/.env"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Config file not found. Copy .env.example to .env and add your ESV_API_TOKEN:" >&2
    echo "  cp \"${SCRIPT_DIR}/.env.example\" \"${CONFIG_FILE}\"" >&2
    exit 1
fi

source "$CONFIG_FILE"

if [[ -z "$ESV_API_TOKEN" || "$ESV_API_TOKEN" == "your-api-token-here" ]]; then
    echo "Error: ESV_API_TOKEN not configured in $CONFIG_FILE" >&2
    exit 1
fi

for _var in INCLUDE_PASSAGE_REFERENCES INCLUDE_VERSE_NUMBERS \
            INCLUDE_FIRST_VERSE_NUMBERS INCLUDE_FOOTNOTES INCLUDE_FOOTNOTE_BODY \
            INCLUDE_HEADINGS INCLUDE_SHORT_COPYRIGHT INCLUDE_PASSAGE_HORIZONTAL_LINES \
            INCLUDE_HEADING_HORIZONTAL_LINES INCLUDE_SELAHS INDENT_POETRY; do
    _val="${!_var:-false}"
    printf -v "$_var" '%s' "${_val,,}"
done
unset _var _val

build_query_params() {
    local params=""

    params="${params}&include-passage-references=${INCLUDE_PASSAGE_REFERENCES}"
    params="${params}&include-verse-numbers=${INCLUDE_VERSE_NUMBERS}"
    params="${params}&include-first-verse-numbers=${INCLUDE_FIRST_VERSE_NUMBERS}"
    params="${params}&include-footnotes=${INCLUDE_FOOTNOTES}"
    params="${params}&include-footnote-body=${INCLUDE_FOOTNOTE_BODY}"
    params="${params}&include-headings=${INCLUDE_HEADINGS}"
    params="${params}&include-short-copyright=${INCLUDE_SHORT_COPYRIGHT}"
    params="${params}&include-passage-horizontal-lines=${INCLUDE_PASSAGE_HORIZONTAL_LINES}"
    params="${params}&include-heading-horizontal-lines=${INCLUDE_HEADING_HORIZONTAL_LINES}"
    params="${params}&include-selahs=${INCLUDE_SELAHS}"
    params="${params}&indent-poetry=${INDENT_POETRY}"
    params="${params}&horizontal-line-length=${HORIZONTAL_LINE_LENGTH}"
    params="${params}&indent-using=${INDENT_USING}"
    params="${params}&indent-paragraphs=${INDENT_PARAGRAPHS}"
    params="${params}&indent-poetry-lines=${INDENT_POETRY_LINES}"
    params="${params}&indent-declares=${INDENT_DECLARES}"
    params="${params}&indent-psalm-doxology=${INDENT_PSALM_DOXOLOGY}"
    params="${params}&line-length=${LINE_LENGTH}"

    echo "$params"
}

fetch_verse() {
    local verse="$1"
    local encoded_verse=${verse// /+}
    local query_params=$(build_query_params)

    if response=$(curl -sf -H "Authorization: Token $ESV_API_TOKEN" "https://api.esv.org/v3/passage/text/?q=$encoded_verse$query_params"); then
        echo "$response" | jq -r ".passages[]?" | while IFS= read -r passage; do
            echo -e "$passage"
        done
        echo ""
    else
        echo "Error fetching: $verse" >&2
        echo ""
    fi
}

show_help() {
    echo "ESV Bible Verse Fetcher"
    echo ""
    echo "Usage: $0 [OPTIONS] [\"verse reference\"]"
    echo ""
    echo "Options:"
    echo "  -h    Show this help message"
    echo "  -c    Show config file location"
    echo "  -e    Edit config file"
    echo ""
    echo "Examples:"
    echo "  $0 \"John 3:16\""
    echo "  $0 \"John 3:16; Romans 8:28\""
    echo "  cat verses.txt | $0"
    echo "  echo \"John 3:16\" | $0"
    echo ""
    echo "Config file: $CONFIG_FILE (see .env.example for all options)"
}

while getopts "hce" opt; do
    case $opt in
    h)
        show_help
        exit 0
        ;;
    c)
        echo "Config file location: $CONFIG_FILE"
        exit 0
        ;;
    e)
        ${EDITOR:-vim} "$CONFIG_FILE"
        exit 0
        ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
    esac
done

shift $((OPTIND - 1))

if [ -p /dev/stdin ]; then
    while IFS= read -r line; do
        [ -n "$line" ] && fetch_verse "$line"
    done
elif [ $# -gt 0 ]; then
    fetch_verse "$1"
else
    show_help
fi
