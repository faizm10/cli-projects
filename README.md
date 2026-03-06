# 🎮 CLI Games Collection

**10 awesome games for your terminal** — Play offline, zero dependencies, pure Bash!

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Bash](https://img.shields.io/badge/Bash-4.0%2B-green.svg)](https://www.gnu.org/software/bash/)
[![Games](https://img.shields.io/badge/Games-10-brightgreen.svg)](#-games)

---

## ✨ Features

- 🎯 **10 Classic & Modern Games** - From Hangman to Snake to Blackjack
- 💻 **Works 100% Offline** - No internet needed after installation
- 🚀 **Zero Dependencies** - Just Bash (already on your system)
- 🎨 **Beautiful UI** - Colorful, intuitive interfaces with emojis
- 📦 **Multiple Install Methods** - Choose what works best for you
- 🌍 **Cross-Platform** - Linux, macOS, WSL, Docker, and more

---

## 🎲 Games

1. **🔢 Number Guess** - Guess the number between 1-100 with smart hints
2. **🎯 Hangman** - Classic word game with ASCII art hangman
3. **❌ Tic-Tac-Toe** - Two-player strategy game with beautiful board
4. **🦖 Infinity Dino** - Chrome's offline dino game in your terminal
5. **🐍 Snake** - Classic snake game with WASD/arrow controls
6. **🪨 Rock Paper Scissors** - Play against the computer with stats
7. **🧠 Memory Game** - Simon Says style color sequence memory test
8. **📝 Wordle** - Guess the 5-letter word with color feedback
9. **💣 Minesweeper** - Classic mine-sweeping puzzle on a 10x10 grid
10. **🎴 Blackjack** - Card game (21) against the dealer with betting

---

## 🚀 Quick Start

### Method 1: One-Line Install (Recommended)

**Download and install instantly** - no need to clone:

```bash
curl -sSL https://raw.githubusercontent.com/faizm10/cli-projects/main/install.sh | bash
```

Then run:

```bash
games
```

### Method 2: NPM/NPX

**Run instantly without installation:**

```bash
npx @faizm10/cli-games
```

**Or install globally:**

```bash
npm install -g @faizm10/cli-games
cli-games
```

### Method 3: Homebrew (macOS/Linux)

```bash
brew tap faizm10/tap
brew install cli-games
games
```

### Method 4: Docker

**Run in a container:**

```bash
docker run -it faizm10/cli-games:latest
```

**Or build locally:**

```bash
git clone https://github.com/faizm10/cli-projects.git
cd cli-projects
./docker-build.sh
docker run -it faizm10/cli-games:latest
```

### Method 5: Standalone File

**Download a single file with all games embedded:**

```bash
curl -sSL https://raw.githubusercontent.com/faizm10/cli-projects/main/cli-games-standalone.sh -o games
chmod +x games
./games
```

No installation needed - just download and run!

### Method 6: Git Clone

```bash
git clone https://github.com/faizm10/cli-projects.git
cd cli-projects
./install.sh
```

### Method 7: Package Managers

**Debian/Ubuntu (.deb):**

```bash
wget https://github.com/faizm10/cli-projects/releases/download/v2.0.0/cli-games_2.0.0_all.deb
sudo dpkg -i cli-games_2.0.0_all.deb
```

**RHEL/Fedora/CentOS (.rpm):**

```bash
wget https://github.com/faizm10/cli-projects/releases/download/v2.0.0/cli-games-2.0.0-1.noarch.rpm
sudo rpm -i cli-games-2.0.0-1.noarch.rpm
```

### Method 8: Offline Install (Air-Gapped Systems)

Download the offline package:

```bash
wget https://github.com/faizm10/cli-projects/releases/download/v2.0.0/cli-games-2.0.0.tar.gz
tar -xzf cli-games-2.0.0.tar.gz
cd cli-games-2.0.0
./install.sh
```

---

## ⚙️ Configuration

### Custom Install Location

```bash
INSTALL_ROOT=~/my-games BIN_DIR=~/bin curl -sSL https://raw.githubusercontent.com/faizm10/cli-projects/main/install.sh | bash
```

### Add to PATH (if needed)

Add to `~/.bashrc` or `~/.zshrc`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Then reload:

```bash
source ~/.bashrc  # or source ~/.zshrc
```

---

## 🔄 Update

Get the latest version:

```bash
games update
```

---

## 🎮 Usage

Simply run:

```bash
games
```

Navigate the menu with numbers (0-10) and press Enter.

Each game has:
- ✅ Clear instructions
- 🎨 Colorful UI
- ⌨️ Intuitive controls
- 🚪 Easy exit (type `quit` or `q`)

---

## 🛠️ Building from Source

### Build Standalone Version

```bash
./build-standalone.sh
# Creates: cli-games-standalone.sh
```

### Build Offline Packages

```bash
./build-offline-package.sh
# Creates: cli-games-VERSION.tar.gz and .zip
```

### Build .deb Package

```bash
./build-deb.sh
# Creates: cli-games_VERSION_all.deb
```

### Build .rpm Package

```bash
./build-rpm.sh
# Creates: cli-games-VERSION-RELEASE.noarch.rpm
```

### Build Docker Image

```bash
./docker-build.sh
# Creates: faizm10/cli-games:latest
```

---

## 📋 Requirements

- **Bash** 4.0 or higher (already installed on most systems)
- **Terminal** with ANSI color support (most modern terminals)
- **Optional**: `curl` for one-line install and updates

That's it! No Python, Node.js, or other runtimes needed.

---

## 🎯 Game Controls

### Universal Controls
- Type `quit`, `q`, or `exit` in any game to return to menu
- Press `Enter` to confirm choices

### Game-Specific Controls
- **Number Guess**: Type numbers 1-100
- **Hangman**: Type single letters A-Z
- **Tic-Tac-Toe**: Type positions 1-9
- **Infinity Dino**: Press `SPACE` to jump, `q` to quit
- **Snake**: Use `WASD` or arrow keys (↑←↓→)
- **Rock Paper Scissors**: Type 1, 2, or 3 (or rock/paper/scissors)
- **Memory Game**: Type 1-4 for colors
- **Wordle**: Type 5-letter words
- **Minesweeper**: Type `r x y` (reveal) or `f x y` (flag)
- **Blackjack**: Type `h` (hit) or `s` (stand)

---

## 🤝 Contributing

Contributions are welcome! Here's how:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-game`)
3. Commit your changes (`git commit -m 'Add amazing new game'`)
4. Push to the branch (`git push origin feature/amazing-game`)
5. Open a Pull Request

### Adding a New Game

1. Create `games/your-game.sh`
2. Add shebang: `#!/usr/bin/env bash`
3. Use `return 0` to exit (not `exit 0`)
4. Add colors and clear instructions
5. Update `games.sh` menu
6. Update `install.sh` and `build-*.sh` scripts
7. Test thoroughly!

---

## 📝 License

MIT License - See [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Inspired by classic terminal games
- Built with ❤️ for the CLI community
- Thanks to all contributors!

---

## 📞 Support

- 🐛 **Issues**: [GitHub Issues](https://github.com/faizm10/cli-projects/issues)
- 💡 **Suggestions**: Open an issue with the `enhancement` tag
- ⭐ **Like it?**: Star the repo!

---

## 🎊 Fun Facts

- All games written in pure Bash
- Total codebase: ~2000 lines
- Zero external dependencies
- Works on systems from 2010+
- Playable over SSH!

---

**Made with 🎮 and Bash**

Enjoy the games! 🚀
