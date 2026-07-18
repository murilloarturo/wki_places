#!/bin/sh

set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

if ! command -v swiftgen >/dev/null 2>&1; then
    echo "error: SwiftGen is required. Install it with 'brew install swiftgen'." >&2
    exit 1
fi

cd "$project_dir"
swiftgen config run --config swiftgen.yml
