class CliGames < Formula
  desc "Collection of 10 fun CLI games - play offline, no dependencies, pure Bash"
  homepage "https://github.com/faizm10/cli-projects"
  url "https://github.com/faizm10/cli-projects/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "" # Update this with actual SHA256 after creating release
  license "MIT"

  def install
    # Install all game files
    (libexec/"games").install Dir["games/*.sh"]

    # Install main script and other files
    libexec.install "games.sh", "install.sh", "README.md"

    # Create executable wrapper
    (bin/"games").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/games.sh" "$@"
    EOS

    chmod 0755, bin/"games"
  end

  test do
    # Test that the command runs
    assert_match "CLI GAMES", shell_output("#{bin}/games 0", 0)
  end

  def caveats
    <<~EOS
      🎮 CLI Games installed successfully!

      Run the following command to start playing:
        games

      Available games:
        1. Number Guess
        2. Hangman
        3. Tic-Tac-Toe
        4. Infinity Dino
        5. Snake
        6. Rock Paper Scissors
        7. Memory Game
        8. Wordle
        9. Minesweeper
        10. Blackjack
    EOS
  end
end
