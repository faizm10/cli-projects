# CLI Games (offline)

Play simple games in your terminal. No runtime to install — just Bash. Works fully offline after install.

## Install (one command)

**Download and install in one line** (like npx/shadcn — no need to clone first):

```bash
curl -sSL https://raw.githubusercontent.com/faizm10/cli-projects/main/install.sh | bash
```

**Or** clone the repo and run the installer from the project directory:

```bash
git clone https://github.com/faizm10/cli-projects.git
cd cli-projects
./install.sh
```

By default the **full project** goes to `~/.local/share/cli-projects/` (same layout as the repo) and a `games` command is added to `~/.local/bin/`. You can install anywhere by setting `INSTALL_ROOT` and optionally `BIN_DIR`:

```bash
INSTALL_ROOT=~/my-projects/cli-projects BIN_DIR=~/bin curl -sSL https://raw.githubusercontent.com/faizm10/cli-projects/main/install.sh | bash
```

## Run

From any directory:

```bash
games
```

To get the latest version after install:

```bash
games update
```

If `games` is not found, add this to your shell config (e.g. `~/.bashrc` or `~/.zshrc`):

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Then open a new terminal or run `source ~/.zshrc` (or `source ~/.bashrc`).

## Games

1. **Number Guess** — Guess a number between 1 and 100. Fewer tries = better.
2. **Hangman** — Guess the word letter by letter. You get 6 wrong guesses.
3. **Tic-Tac-Toe** — Two players (X and O). Use positions 1–9 to play.
4. **Infinity Dino** — Run and jump over cacti (SPACE to jump). Score = obstacles passed.

All games run offline. No dependencies except Bash.
