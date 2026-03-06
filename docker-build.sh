#!/usr/bin/env bash
# Build and optionally push the CLI Games Docker image

set -e

IMAGE_NAME="${IMAGE_NAME:-faizm10/cli-games}"
VERSION="${VERSION:-2.0.0}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🐳 Building Docker image for CLI Games..."
echo "Image: $IMAGE_NAME:$VERSION"
echo ""

# Build the image
echo "Building image..."
docker build -t "$IMAGE_NAME:$VERSION" -t "$IMAGE_NAME:latest" "$SCRIPT_DIR"

echo ""
echo "✅ Docker image built successfully!"
echo ""
echo "Image tags:"
echo "  • $IMAGE_NAME:$VERSION"
echo "  • $IMAGE_NAME:latest"
echo ""
echo "Usage:"
echo "  Run interactively:"
echo "    docker run -it $IMAGE_NAME:latest"
echo ""
echo "  Run specific game (example - Number Guess):"
echo "    docker run -it $IMAGE_NAME:latest"
echo ""
echo "Push to registry:"
echo "  docker push $IMAGE_NAME:$VERSION"
echo "  docker push $IMAGE_NAME:latest"
