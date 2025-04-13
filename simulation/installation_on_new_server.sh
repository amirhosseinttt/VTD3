#!/bin/bash

# run docker_installation script
docker_installation() {
    # Check if Docker is installed
    if ! command -v docker &> /dev/null
    then
        echo "Docker not found. Installing Docker..."
        # Install Docker
        curl -fsSL https://get.docker.com -o get-docker.sh
        sh get-docker.sh
        # Clean up installation script
        rm get-docker.sh
    else
        echo "Docker is already installed."
    fi

    # Add user to the docker group
    sudo usermod -aG docker $USER

    # Start Docker service
    sudo systemctl start docker

    # Enable Docker to start on boot
    sudo systemctl enable docker
}

# Run the docker installation function
docker_installation

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null
then
    echo "Docker Compose not found. Installing Docker Compose..."
    
    # Install Docker Compose (v2 is now part of Docker CLI as 'docker compose')
    # For standalone installation (older method):
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    
    # Verify installation
    docker-compose --version
else
    echo "Docker Compose is already installed."
    docker-compose --version
fi

# Verify Docker installation
docker --version

# Verify Docker Compose installation
docker-compose --version
