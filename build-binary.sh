#!/bin/bash

# Build script to create and extract the ntlmrelayx binary

set -e  # Exit on error

echo "Building Docker image..."
if ! docker build -t ntlmrelayx-builder .; then
    echo "ERROR: Docker build failed!"
    exit 1
fi

echo "Creating temporary container..."
CONTAINER_ID=$(docker create ntlmrelayx-builder)

echo "Extracting binary to ./ntlmrelayx..."
if ! docker cp "$CONTAINER_ID:/usr/local/bin/ntlmrelayx" ./ntlmrelayx; then
    echo "ERROR: Failed to extract binary from container!"
    docker rm "$CONTAINER_ID" || true
    exit 1
fi

echo "Cleaning up temporary container..."
docker rm "$CONTAINER_ID"

# Verify binary exists and is executable
if [ -f ./ntlmrelayx ]; then
    chmod +x ./ntlmrelayx
    echo "✓ Binary extracted successfully to: ./ntlmrelayx"
    echo "You can now use ./ntlmrelayx as a standalone binary"
else
    echo "ERROR: Binary file not found after extraction!"
    exit 1
fi
