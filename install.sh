#!/bin/bash

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Try with sudo."
    exit 1
fi


