#!/bin/bash

# Function to install packages on Ubuntu or Debian
install_packages_debian() {
    sudo apt update
    sudo apt install -y ruby-full wget
}

# Function to install packages on CentOS, Fedora, or RHEL
install_packages_redhat() {
    sudo yum install -y ruby wget
}

# Function to install packages on Arch Linux
install_packages_arch() {
    sudo pacman -Sy ruby wget --noconfirm
}

# Detect the Linux distribution and install packages
if [ -f /etc/os-release ]; then
    . /etc/os-release
    case $ID in
        ubuntu|debian)
            install_packages_debian
            ;;
        centos|fedora|rhel)
            install_packages_redhat
            ;;
        arch)
            install_packages_arch
            ;;
        *)
            echo "Unsupported distribution: $ID"
            exit 1
            ;;
    esac
else
    echo "Cannot detect Linux distribution"
    exit 1
fi

# Get the latest release information
REPO="RukuLab/bootstrap"
RELEASE_INFO=$(curl -s https://api.github.com/repos/$REPO/releases/latest)

# Extract the tag name
TAG_NAME=$(echo $RELEASE_INFO | jq -r '.tag_name')
FILE_NAME="$TAG_NAME.tar.gz"

# Construct the download URL
DOWNLOAD_URL="https://github.com/$REPO/archive/refs/tags/$FILE_NAME"

# Download the file using wget
wget "$DOWNLOAD_URL"

# Unzip the file
tar -xzf "$FILE_NAME"

# Get the unzipped directory name
UNZIPPED_DIR="bootstrap-${TAG_NAME#v}"

# Change to the unzipped directory
cd "$UNZIPPED_DIR"

# Run the Ruby script
ruby main.rb

# Change back to the original directory
cd ..

# Remove the zipped file and unzipped directory
rm -rf "$FILE_NAME" "$UNZIPPED_DIR"
