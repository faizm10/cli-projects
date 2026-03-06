# Changelog

All notable changes to CLI Games will be documented in this file.

## [2.0.0] - 2024

### 🎮 Major Update - 10 Games Edition

### Added

#### 6 New Games
1. **Snake** - Classic snake game with WASD/arrow key controls
2. **Rock Paper Scissors** - Play against computer with score tracking
3. **Memory Game** - Simon Says style color sequence challenge
4. **Wordle** - Guess the 5-letter word with color feedback
5. **Minesweeper** - Classic 10x10 mine-sweeping puzzle
6. **Blackjack** - Card game (21) with betting system

#### Enhanced Existing Games
- **Number Guess** - Added colors, better hints, range tracking, quit option
- **Hangman** - ASCII art hangman, colors, better word bank
- **Tic-Tac-Toe** - Beautiful Unicode board, colors, better UX
- **Infinity Dino** - Emojis, colors, high score tracking

#### Multiple Distribution Methods
1. **NPM Package** - Install via `npm` or run with `npx`
2. **Homebrew Formula** - Install on macOS/Linux with `brew`
3. **Standalone Single-File** - Download one file with all games embedded
4. **Offline Packages** - tar.gz and zip for air-gapped systems
5. **Docker Image** - Run in containers for ultimate portability
6. **Debian Package (.deb)** - Native package for Debian/Ubuntu
7. **RPM Package (.rpm)** - Native package for RHEL/Fedora/CentOS
8. **Original Install Script** - Still works as before

#### Build Scripts
- `build-standalone.sh` - Creates single-file version
- `build-offline-package.sh` - Creates tar.gz and zip packages
- `build-deb.sh` - Creates .deb package
- `build-rpm.sh` - Creates .rpm package
- `docker-build.sh` - Builds Docker image

#### Configuration Files
- `package.json` - NPM package configuration
- `Dockerfile` - Docker image configuration
- `.dockerignore` - Docker build optimization
- `cli-games.rb` - Homebrew formula
- `.gitignore` - Git ignore patterns
- `LICENSE` - MIT license file

### Improved
- **UI/UX** - All games now have:
  - 🎨 Colorful interfaces with ANSI colors
  - ✨ Emoji indicators for better visual feedback
  - 📦 Bordered boxes and clean layouts
  - ⌨️ Intuitive controls with hints
  - 🚪 Easy exit with `quit` or `q` commands
  - 📋 Clear instructions before each game
  - 🏆 Better feedback and celebrations

- **Main Menu** - Enhanced with:
  - Beautiful bordered design
  - Color-coded game list with emojis
  - Better navigation (0-10)
  - Consistent styling

- **Documentation**
  - Comprehensive README with 8 installation methods
  - Detailed game controls section
  - Build instructions
  - Contributing guidelines
  - Changelog

### Technical Improvements
- All games use consistent color scheme
- Better error handling and input validation
- Improved code organization
- Modular game design
- Better terminal cleanup on exit
- Cross-platform compatibility verified

### Files Added
```
games/snake.sh              # New Snake game
games/rps.sh                # New Rock Paper Scissors
games/memory.sh             # New Memory game
games/wordle.sh             # New Wordle game
games/minesweeper.sh        # New Minesweeper game
games/blackjack.sh          # New Blackjack game
package.json                # NPM package config
npm-bin.sh                  # NPM executable wrapper
npm-install.sh              # NPM post-install script
cli-games.rb                # Homebrew formula
Dockerfile                  # Docker image
.dockerignore               # Docker build optimization
build-standalone.sh         # Standalone builder
build-offline-package.sh    # Offline package builder
build-deb.sh                # Debian package builder
build-rpm.sh                # RPM package builder
docker-build.sh             # Docker build script
LICENSE                     # MIT license
.gitignore                  # Git ignore file
CHANGELOG.md                # This file
```

### Distribution
- Available on NPM: `@faizm10/cli-games`
- Available on Docker Hub: `faizm10/cli-games`
- Available on GitHub Releases with pre-built packages
- Can be installed via Homebrew tap

---

## [1.0.0] - Initial Release

### Added
- 4 Initial games:
  1. Number Guess
  2. Hangman
  3. Tic-Tac-Toe
  4. Infinity Dino
- Basic install script
- Main menu system
- Update functionality
- README documentation

### Features
- Offline play capability
- Zero dependencies (Bash only)
- Easy one-line installation
- Update command

---

## Future Plans

### Potential Additions
- More games (Chess, Connect Four, Sudoku, etc.)
- Difficulty levels for existing games
- High score persistence
- Multiplayer over network
- Sound effects (optional)
- Themes/color schemes
- Save game state
- Achievements system

### Under Consideration
- Web version
- Mobile terminal apps
- Game statistics tracking
- Leaderboards (optional online)

---

**Note**: This project follows [Semantic Versioning](https://semver.org/).
