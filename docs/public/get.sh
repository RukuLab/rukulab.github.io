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

# Download and run the Ruby script
wget https://raw.githubusercontent.com/RukuLab/bootstrap/main/setup.rb
ruby setup.rb
rm setup.rb
