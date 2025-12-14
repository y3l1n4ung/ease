#!/bin/bash
# Build the Ease DevTools extension

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST_DIR="$SCRIPT_DIR/extension/devtools/build"

echo "Building Ease DevTools extension..."
cd "$SCRIPT_DIR"

# Build for web
flutter build web --release

# Copy to extension folder
echo "Copying build to extension folder..."
rm -rf "$DEST_DIR"
cp -r "$SCRIPT_DIR/build/web" "$DEST_DIR"

echo "Done! Extension built at:"
echo "  $DEST_DIR"
