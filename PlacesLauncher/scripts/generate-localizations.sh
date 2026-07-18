#!/bin/sh

set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

swiftgen_bin=$(command -v swiftgen 2>/dev/null || true)

if [ -z "$swiftgen_bin" ] && [ -x /opt/homebrew/bin/swiftgen ]; then
    swiftgen_bin=/opt/homebrew/bin/swiftgen
fi

if [ -z "$swiftgen_bin" ] && [ -x /usr/local/bin/swiftgen ]; then
    swiftgen_bin=/usr/local/bin/swiftgen
fi

if [ -z "$swiftgen_bin" ]; then
    echo "error: SwiftGen is required. Install it with 'brew install swiftgen'." >&2
    exit 1
fi

cd "$project_dir"
"$swiftgen_bin" config run --config swiftgen.yml
