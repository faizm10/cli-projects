#!/usr/bin/env bash
# Build .deb package for Debian/Ubuntu systems

set -e

VERSION="${VERSION:-2.0.0}"
ARCH="${ARCH:-all}"
PKG_NAME="cli-games"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="/tmp/${PKG_NAME}-${VERSION}"

echo "Building .deb package for CLI Games..."
echo "Version: $VERSION"
echo "Architecture: $ARCH"
echo ""

# Clean and create build directory
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR/DEBIAN"
mkdir -p "$BUILD_DIR/usr/share/cli-games/games"
mkdir -p "$BUILD_DIR/usr/bin"

# Create control file
cat > "$BUILD_DIR/DEBIAN/control" << EOF
Package: cli-games
Version: $VERSION
Section: games
Priority: optional
Architecture: $ARCH
Maintainer: Faiz M <faiz@example.com>
Description: Collection of 10 fun CLI games
 Play 10 classic and modern games directly in your terminal:
 - Number Guess
 - Hangman
 - Tic-Tac-Toe
 - Infinity Dino
 - Snake
 - Rock Paper Scissors
 - Memory Game
 - Wordle
 - Minesweeper
 - Blackjack
 .
 Works completely offline with no dependencies beyond Bash.
Depends: bash (>= 4.0)
Homepage: https://github.com/faizm10/cli-projects
EOF

# Create postinst script
cat > "$BUILD_DIR/DEBIAN/postinst" << 'EOF'
#!/bin/bash
set -e

# Make scripts executable
chmod +x /usr/share/cli-games/games.sh
chmod +x /usr/share/cli-games/games/*.sh
chmod +x /usr/bin/games

echo ""
echo "✅ CLI Games installed successfully!"
echo ""
echo "Run 'games' to start playing!"
echo ""

exit 0
EOF
chmod +x "$BUILD_DIR/DEBIAN/postinst"

# Create prerm script
cat > "$BUILD_DIR/DEBIAN/prerm" << 'EOF'
#!/bin/bash
set -e
exit 0
EOF
chmod +x "$BUILD_DIR/DEBIAN/prerm"

# Copy files
echo "Copying files..."
cp "$SCRIPT_DIR/games.sh" "$BUILD_DIR/usr/share/cli-games/"
cp "$SCRIPT_DIR/install.sh" "$BUILD_DIR/usr/share/cli-games/"
cp "$SCRIPT_DIR/README.md" "$BUILD_DIR/usr/share/cli-games/"
cp "$SCRIPT_DIR/games/"*.sh "$BUILD_DIR/usr/share/cli-games/games/"

# Create wrapper script in /usr/bin
cat > "$BUILD_DIR/usr/bin/games" << 'EOF'
#!/usr/bin/env bash
exec /usr/share/cli-games/games.sh "$@"
EOF
chmod +x "$BUILD_DIR/usr/bin/games"

# Build the package
echo "Building package..."
DEB_FILE="${SCRIPT_DIR}/${PKG_NAME}_${VERSION}_${ARCH}.deb"
dpkg-deb --build "$BUILD_DIR" "$DEB_FILE"

# Cleanup
rm -rf "$BUILD_DIR"

echo ""
echo "✅ .deb package created successfully!"
echo ""
echo "File: ${PKG_NAME}_${VERSION}_${ARCH}.deb"
echo "Size: $(ls -lh "$DEB_FILE" | awk '{print $5}')"
echo ""
echo "Installation:"
echo "  sudo dpkg -i ${PKG_NAME}_${VERSION}_${ARCH}.deb"
echo ""
echo "Removal:"
echo "  sudo dpkg -r $PKG_NAME"
