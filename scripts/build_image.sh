#!/bin/bash

# Script to build a Docker image from a Dockerfile if it doesn't already exist
# Usage: ./build_container.sh <path-to-dockerfile> <image-name>

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <path-to-dockerfile> <image-name>"
    echo "Example: $0 ./Dockerfile myimage:latest"
    exit 1
fi

# Assign arguments to variables
DOCKERFILE_PATH=$1
IMAGE_NAME=$2

# Check if the Dockerfile exists
if [ ! -f "$DOCKERFILE_PATH" ]; then
    echo "Error: Dockerfile not found at path: $DOCKERFILE_PATH"
    exit 1
fi

# Get the directory containing the Dockerfile
DOCKER_CONTEXT=$(dirname "$DOCKERFILE_PATH")

# Check if the Docker image already exists
if docker image inspect "$IMAGE_NAME" &> /dev/null; then
    echo "Image '$IMAGE_NAME' already exists."
    echo "To rebuild the image, either use a different name or delete the existing image first:"
    echo "  docker rmi $IMAGE_NAME"
    exit 0
else
    echo "Image '$IMAGE_NAME' not found. Building now..."
    
    # Build the Docker image
    docker build -f "$DOCKERFILE_PATH" -t "$IMAGE_NAME" "$DOCKER_CONTEXT"
    
    # Check if the build was successful
    if [ $? -eq 0 ]; then
        echo "Successfully built Docker image: $IMAGE_NAME"
    else
        echo "Failed to build Docker image: $IMAGE_NAME"
        exit 1
    fi
fi