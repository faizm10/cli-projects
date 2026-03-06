#!/usr/bin/env bash
# Build .rpm package for RHEL/Fedora/CentOS systems

set -e

VERSION="${VERSION:-2.0.0}"
RELEASE="${RELEASE:-1}"
ARCH="${ARCH:-noarch}"
PKG_NAME="cli-games"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="/tmp/${PKG_NAME}-rpm-build"
SPEC_FILE="$BUILD_DIR/SPECS/${PKG_NAME}.spec"

echo "Building .rpm package for CLI Games..."
echo "Version: $VERSION"
echo "Release: $RELEASE"
echo "Architecture: $ARCH"
echo ""

# Create RPM build directories
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

# Create source tarball
echo "Creating source tarball..."
SOURCE_DIR="/tmp/${PKG_NAME}-${VERSION}"
rm -rf "$SOURCE_DIR"
mkdir -p "$SOURCE_DIR/games"

cp "$SCRIPT_DIR/games.sh" "$SOURCE_DIR/"
cp "$SCRIPT_DIR/install.sh" "$SOURCE_DIR/"
cp "$SCRIPT_DIR/README.md" "$SOURCE_DIR/"
cp "$SCRIPT_DIR/games/"*.sh "$SOURCE_DIR/games/"

cd /tmp
tar -czf "$BUILD_DIR/SOURCES/${PKG_NAME}-${VERSION}.tar.gz" "${PKG_NAME}-${VERSION}"
rm -rf "$SOURCE_DIR"

# Create spec file
cat > "$SPEC_FILE" << EOF
Name:           cli-games
Version:        $VERSION
Release:        $RELEASE
Summary:        Collection of 10 fun CLI games
License:        MIT
URL:            https://github.com/faizm10/cli-projects
Source0:        %{name}-%{version}.tar.gz
BuildArch:      noarch
Requires:       bash >= 4.0

%description
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

Works completely offline with no dependencies beyond Bash.

%prep
%setup -q

%build
# No build needed - pure bash scripts

%install
rm -rf \$RPM_BUILD_ROOT
mkdir -p \$RPM_BUILD_ROOT/usr/share/cli-games/games
mkdir -p \$RPM_BUILD_ROOT/usr/bin

# Copy game files
cp games.sh \$RPM_BUILD_ROOT/usr/share/cli-games/
cp install.sh \$RPM_BUILD_ROOT/usr/share/cli-games/
cp README.md \$RPM_BUILD_ROOT/usr/share/cli-games/
cp games/*.sh \$RPM_BUILD_ROOT/usr/share/cli-games/games/

# Create wrapper script
cat > \$RPM_BUILD_ROOT/usr/bin/games << 'WRAPPER'
#!/usr/bin/env bash
exec /usr/share/cli-games/games.sh "\$@"
WRAPPER
chmod +x \$RPM_BUILD_ROOT/usr/bin/games

%files
%defattr(-,root,root,-)
%attr(0755,root,root) /usr/bin/games
%attr(0755,root,root) /usr/share/cli-games/games.sh
%attr(0755,root,root) /usr/share/cli-games/install.sh
%attr(0755,root,root) /usr/share/cli-games/games/*.sh
%doc /usr/share/cli-games/README.md

%post
echo ""
echo "✅ CLI Games installed successfully!"
echo ""
echo "Run 'games' to start playing!"
echo ""

%changelog
* $(date "+%a %b %d %Y") Faiz M <faiz@example.com> - $VERSION-$RELEASE
- Version $VERSION release
- 10 games: Number Guess, Hangman, Tic-Tac-Toe, Dino, Snake, RPS, Memory, Wordle, Minesweeper, Blackjack
- Enhanced UI with colors and better instructions
- Multiple distribution formats
EOF

# Build the RPM
echo "Building RPM package..."
rpmbuild --define "_topdir $BUILD_DIR" -ba "$SPEC_FILE"

# Copy the built RPM
RPM_FILE=$(find "$BUILD_DIR/RPMS" -name "*.rpm" | head -n 1)
if [ -n "$RPM_FILE" ]; then
  cp "$RPM_FILE" "$SCRIPT_DIR/"
  RPM_FILENAME=$(basename "$RPM_FILE")

  # Cleanup
  rm -rf "$BUILD_DIR"

  echo ""
  echo "✅ .rpm package created successfully!"
  echo ""
  echo "File: $RPM_FILENAME"
  echo "Size: $(ls -lh "$SCRIPT_DIR/$RPM_FILENAME" | awk '{print $5}')"
  echo ""
  echo "Installation:"
  echo "  sudo rpm -i $RPM_FILENAME"
  echo "  or"
  echo "  sudo yum install $RPM_FILENAME"
  echo "  or"
  echo "  sudo dnf install $RPM_FILENAME"
  echo ""
  echo "Removal:"
  echo "  sudo rpm -e cli-games"
else
  echo "❌ Error: RPM build failed"
  exit 1
fi
