# CLI Games - Docker Image
# Provides a containerized environment to play all 10 CLI games
# Ultimate portability - run anywhere Docker is available

FROM bash:5.2-alpine3.19

# Add metadata
LABEL maintainer="Faiz M"
LABEL description="Collection of 10 fun CLI games - playable in Docker"
LABEL version="2.0.0"

# Install minimal dependencies (none needed for games, but useful for container)
RUN apk add --no-cache coreutils ncurses

# Create app directory
WORKDIR /app

# Copy game files
COPY games.sh .
COPY install.sh .
COPY README.md .
COPY games/ ./games/

# Make scripts executable
RUN chmod +x games.sh install.sh games/*.sh

# Create symbolic link for easy access
RUN ln -s /app/games.sh /usr/local/bin/games

# Set default command
CMD ["games"]

# Health check (optional)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD games 0 || exit 1
