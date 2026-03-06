#!/usr/bin/env bash
# Build offline installation packages (tar.gz and zip) for air-gapped systems

set -e

VERSION="${VERSION:-2.0.0}"
PKG_NAME="cli-games-${VERSION}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="/tmp/${PKG_NAME}"

echo "Building offline installation packages..."
echo "Version: $VERSION"
echo ""

# Clean and create build directory
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
mkdir -p "$BUILD_DIR/games"

# Copy files
echo "Copying files..."
cp "$SCRIPT_DIR/games.sh" "$BUILD_DIR/"
cp "$SCRIPT_DIR/install.sh" "$BUILD_DIR/"
cp "$SCRIPT_DIR/README.md" "$BUILD_DIR/"
cp "$SCRIPT_DIR/games/"*.sh "$BUILD_DIR/games/"

# Make scripts executable
chmod +x "$BUILD_DIR/games.sh"
chmod +x "$BUILD_DIR/install.sh"
chmod +x "$BUILD_DIR/games/"*.sh

# Create installation instructions
cat > "$BUILD_DIR/INSTALL.txt" << 'EOF'
CLI GAMES - Offline Installation
=================================

This package contains all files needed to install CLI Games offline.

Installation Steps:
-------------------

1. Extract this archive:
   tar -xzf cli-games-VERSION.tar.gz
   (or unzip cli-games-VERSION.zip)

2. Navigate to the extracted directory:
   cd cli-games-VERSION

3. Run the installer:
   ./install.sh

4. Add to your PATH (if needed):
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
   source ~/.bashrc

5. Run the games:
   games

Features:
---------
✓ 10 awesome CLI games
✓ Works 100% offline
✓ No external dependencies
✓ Pure Bash implementation

Games Included:
---------------
1. Number Guess - Guess the number between 1-100
2. Hangman - Classic word guessing game
3. Tic-Tac-Toe - Two-player strategy game
4. Infinity Dino - Jump over obstacles
5. Snake - Classic snake game
6. Rock Paper Scissors - Play against the computer
7. Memory Game - Test your memory (Simon Says style)
8. Wordle - Guess the 5-letter word
9. Minesweeper - Classic mine-sweeping puzzle
10. Blackjack - Card game (21)

Enjoy!
EOF

# Build tar.gz
echo "Creating ${PKG_NAME}.tar.gz..."
cd /tmp
tar -czf "${SCRIPT_DIR}/${PKG_NAME}.tar.gz" "$PKG_NAME"

# Build zip (if zip command exists)
if command -v zip >/dev/null 2>&1; then
  echo "Creating ${PKG_NAME}.zip..."
  cd /tmp
  zip -qr "${SCRIPT_DIR}/${PKG_NAME}.zip" "$PKG_NAME"
else
  echo "⚠️  zip command not found, skipping .zip creation"
fi

# Cleanup
rm -rf "$BUILD_DIR"

echo ""
echo "✅ Offline packages created successfully!"
echo ""
echo "Files created:"
echo "  📦 ${PKG_NAME}.tar.gz"
[ -f "${SCRIPT_DIR}/${PKG_NAME}.zip" ] && echo "  📦 ${PKG_NAME}.zip"
echo ""
echo "Distribution:"
echo "  Share these files for offline installation"
echo "  Users can extract and run ./install.sh"
echo ""
echo "File sizes:"
ls -lh "${SCRIPT_DIR}/${PKG_NAME}.tar.gz" | awk '{print "  " $9 ": " $5}'
[ -f "${SCRIPT_DIR}/${PKG_NAME}.zip" ] && ls -lh "${SCRIPT_DIR}/${PKG_NAME}.zip" | awk '{print "  " $9 ": " $5}'
