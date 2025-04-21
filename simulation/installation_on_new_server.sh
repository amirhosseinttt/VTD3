#!/bin/bash

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Try with sudo."
    exit 1
fi

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



# change dns to 185.51.200.2 - 178.22.122.100
# Shecan DNS configuration script
# Sets primary DNS to 178.22.122.100 and secondary to 185.51.200.2



# Backup current resolv.conf
echo "Backing up current DNS configuration to /etc/resolv.conf.backup"
cp /etc/resolv.conf /etc/resolv.conf.backup

# Set new DNS servers
echo "Setting DNS servers to Shecan DNS..."
echo "nameserver 178.22.122.100" > /etc/resolv.conf
echo "nameserver 185.51.200.2" >> /etc/resolv.conf

# Make the change persistent (for systems using resolvconf)
if command -v resolvconf &>/dev/null; then
    echo "Making DNS changes persistent via resolvconf..."
    resolvconf -u
fi

# For NetworkManager systems
if command -v nmcli &>/dev/null; then
    echo "Configuring NetworkManager to use Shecan DNS..."
    nmcli connection modify $(nmcli -t -f NAME,UUID connection show | head -n1 | cut -d: -f2) ipv4.dns "178.22.122.100 185.51.200.2"
    nmcli connection up $(nmcli -t -f NAME,UUID connection show | head -n1 | cut -d: -f1)
fi

# Verify the change
echo -e "\nNew DNS configuration:"
cat /etc/resolv.conf
echo -e "\nTesting DNS resolution (shecan.ir should resolve):"
nslookup shecan.ir

echo -e "\nDNS configuration complete!"
