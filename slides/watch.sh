#!/bin/bash
# Watch and compile Typst files with local Polylux package
# Usage: ./watch.sh <input-file.typ> [output-file.pdf]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ $# -lt 1 ]; then
    echo "Usage: $0 <input-file.typ> [output-file.pdf]"
    exit 1
fi

INPUT_FILE="$1"
OUTPUT_FILE="${2:-${INPUT_FILE%.typ}.pdf}"

# Set the local packages directory
export TYPST_PACKAGE_PATH="$SCRIPT_DIR/packages"

# Watch and compile with local packages directory
typst watch "$INPUT_FILE" "$OUTPUT_FILE"
