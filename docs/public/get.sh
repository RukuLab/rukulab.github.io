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

REPO="RukuLab/bootstrap"
PAAS_USERNAME=ruku
TEMP_PUB_KEY=/tmp/pubkey

# Function to get the latest release information
get_latest_release_info() {
    RELEASE_INFO=$(curl -s https://api.github.com/repos/$REPO/releases/latest)
    TAG_NAME=$(echo "$RELEASE_INFO" | jq -r '.tag_name')
    FILE_NAME="$TAG_NAME.tar.gz"
    DOWNLOAD_URL="https://github.com/$REPO/archive/refs/tags/$FILE_NAME"
}

# Function to download and unzip the file
download_and_unzip() {
    wget -q --show-progress "$DOWNLOAD_URL" && tar -xzf "$FILE_NAME"
    UNZIPPED_DIR="bootstrap-${TAG_NAME#v}"
}

# Function to check if the user exists and belongs to the specified groups
user_exists_and_in_groups() {
    id "$PAAS_USERNAME" >/dev/null 2>&1 &&
    groups "$PAAS_USERNAME" | grep -q "\bwww-data\b" &&
    groups "$PAAS_USERNAME" | grep -q "\bdocker\b"
}

# Function to create a user and set up SSH keys
create_user_and_setup_ssh() {
    if [ -s ~/.ssh/authorized_keys ]; then
        AUTHORIZED_KEYS_CONTENT=$(cat ~/.ssh/authorized_keys)
        if [ -n "$AUTHORIZED_KEYS_CONTENT" ]; then
            head -1 ~/.ssh/authorized_keys > $TEMP_PUB_KEY
        else
            echo "Error: ~/.ssh/authorized_keys is empty" >&2
            exit 1
        fi
    else
        echo "Error: No authorized keys found in ~/.ssh" >&2
        exit 1
    fi

    sudo adduser --disabled-password --gecos 'PaaS access' --ingroup www-data $PAAS_USERNAME
    sudo usermod -aG docker $PAAS_USERNAME
    sudo su - $PAAS_USERNAME -c "wget -q --show-progress $DOWNLOAD_URL && tar -xzf $FILE_NAME && ruby ~/$UNZIPPED_DIR/ssh.rb $TEMP_PUB_KEY && ruby ~/$UNZIPPED_DIR/setup.rb"
    sudo su - $PAAS_USERNAME -c "rm -rf \"$FILE_NAME\" \"$UNZIPPED_DIR\""
}

get_latest_release_info
download_and_unzip

# Run the Ruby script to install ruku
ruby ~/"$UNZIPPED_DIR"/main.rb

if user_exists_and_in_groups; then
    echo "User $PAAS_USERNAME already exists and belongs to both www-data and docker groups."
else
    create_user_and_setup_ssh
fi
rm -rf "$FILE_NAME" "$UNZIPPED_DIR" "$TEMP_PUB_KEY"
