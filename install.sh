#!/bin/bash

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Try with sudo."
    exit 1
fi

SCRIPTS_PATH=./scripts/



# step-1: install docker and docker compose
echo "Installing Docker..."
filename=install_docker.sh
if [ -f "$SCRIPTS_PATH$filename" ]; then
    echo "Running $filename..."
    bash "$SCRIPTS_PATH$filename"
else
    echo "$filename not found in $SCRIPTS_PATH"
fi



# step-2: change system DNS to shecan
echo "Changing system DNS to Shecan..."
filename=change_dns.sh
if [ -f "$SCRIPTS_PATH$filename" ]; then
    echo "Running $filename..."
    bash "$SCRIPTS_PATH$filename"
else
    echo "$filename not found in $SCRIPTS_PATH"
fi


# step-2.1: change docker DNS to shecan
echo "Changing Docker DNS to Shecan..."
filename=configure_docker_dns.sh
if [ -f "$SCRIPTS_PATH$filename" ]; then
    echo "Running $filename..."
    bash "$SCRIPTS_PATH$filename"
else
    echo "$filename not found in $SCRIPTS_PATH"
fi



# step-3: create px4-gazebo-sitl docker image
echo "Building px4-gazebo-sitl Docker image..."
DOCKERFILE_NAME=PX4_Dockerfile
IMAGE_NAME=px4-gazebo-sitl:latest
filename=build_image.sh
if [ -f "$SCRIPTS_PATH$filename" ]; then
    echo "Running $filename..."
    bash "$SCRIPTS_PATH$filename" "$(pwd)/$DOCKERFILE_NAME" "$IMAGE_NAME"
else
    echo "$filename not found in $SCRIPTS_PATH"
fi




# step-4: create ROS2 docker image
echo "Building ROS2 Docker image..."
DOCKERFILE_NAME=ROS2_Dockerfile
IMAGE_NAME=ros2:latest
filename=build_image.sh
if [ -f "$SCRIPTS_PATH$filename" ]; then
    echo "Running $filename..."
    bash "$SCRIPTS_PATH$filename" "$(pwd)/$DOCKERFILE_NAME" "$IMAGE_NAME"
else
    echo "$filename not found in $SCRIPTS_PATH"
fi


# step-5: start the docker compose service
echo "Starting Docker Compose service..."
docker-compose up --wait



# final-step
echo "Installation completed successfully!"