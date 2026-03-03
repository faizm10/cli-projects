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

This installs the games to `~/.local/share/cli-games/` and adds a `games` command to `~/.local/bin/`.

## Run

From any directory:

```bash
games
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

All games run offline. No dependencies except Bash.
