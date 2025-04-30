#!/bin/bash

# Script to configure Docker to use Shecan DNS servers
# This script needs to be run with sudo privileges

echo "Configuring Docker to use Shecan DNS servers..."

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)"
  exit 1
fi

# Create Docker daemon configuration directory if it doesn't exist
mkdir -p /etc/docker

# Check if daemon.json exists and back it up if it does
if [ -f /etc/docker/daemon.json ]; then
  echo "Backing up current Docker configuration..."
  cp /etc/docker/daemon.json /etc/docker/daemon.json.backup.$(date +%Y%m%d%H%M%S)
  
  # Update existing daemon.json file with DNS settings
  TEMP_FILE=$(mktemp)
  jq '. + {"dns": ["178.22.122.100", "185.51.200.2"]}' /etc/docker/daemon.json > "$TEMP_FILE"
  mv "$TEMP_FILE" /etc/docker/daemon.json
else
  # Create a new daemon.json file with DNS settings
  cat > /etc/docker/daemon.json << EOF
{
  "dns": ["178.22.122.100", "185.51.200.2"]
}
EOF
fi

# Make sure the file has the right permissions
chmod 644 /etc/docker/daemon.json

echo "Docker configuration updated. Restarting Docker service..."

# Restart Docker service to apply changes
systemctl restart docker

echo "Docker has been configured to use Shecan DNS servers."
echo "Primary DNS: 178.22.122.100"
echo "Secondary DNS: 185.51.200.2"

# Check docker status
echo "Checking Docker service status..."
systemctl status docker --no-pager | head -n 10

echo "Done!"