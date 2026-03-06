#!/usr/bin/env bash
# NPM wrapper for CLI games - runs from node_modules

# Get the directory where this script is located (in node_modules)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Run the main games.sh script
exec "$SCRIPT_DIR/games.sh" "$@"
