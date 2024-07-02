#!/bin/bash

# Function to install Ruby on Ubuntu or Debian
install_ruby_debian() {
    sudo apt update
    sudo apt install -y ruby-full
}

# Function to install Ruby on CentOS, Fedora, or RHEL
install_ruby_redhat() {
    sudo yum install -y ruby
}

# Function to install Ruby on Arch Linux
install_ruby_arch() {
    sudo pacman -Sy ruby --noconfirm
}

# Detect the Linux distribution and install Ruby
if [ -f /etc/os-release ]; then
    . /etc/os-release
    case $ID in
        ubuntu|debian)
            install_ruby_debian
            ;;
        centos|fedora|rhel)
            install_ruby_redhat
            ;;
        arch)
            install_ruby_arch
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
curl -o setup.rb https://raw.githubusercontent.com/RukuLab/bootstrap/main/setup.rb
ruby setup.rb
