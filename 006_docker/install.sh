#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

# Install docker engine 
if [[ $OSTYPE == "darwin"* ]]; then
    # From https://dhwaneetbhatt.com/blog/run-docker-without-docker-desktop-on-macos
    # TODO: Need to fully test this
    run_command "installing dependencies" \
        "brew install qemu minikube docker docker-compose"
else
    # From https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
    run_command "installing dependencies" \
        "sudo apt-get install -y \\
        ca-certificates \\
        curl \\
        gnupg \\
        lsb-release"

    if [[ ! -f /etc/apt/keyrings/docker.gpg ]]; then
        # Setup gpg keys and apt sources list
        run_command "creating /etc/apt/keyrings/docker.gpg" \
            "sudo mkdir -p /etc/apt/keyrings" \
            "curl -fsSL https://download.docker.com/linux/ubuntu/gpg \\
            | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg"
    fi

    if ! grep -i "docker" /etc/apt/sources.list.d/docker.list > /dev/null 2>&1; then
        run_command "adding /etc/apt/keyrings/docker.gpg to -> /etc/apt/sources.list.d/docker.list" \
            "echo deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \\
            $(lsb_release -cs) stable | /etc/apt/sources.list.d/docker.list"
    fi

    # Install the docker engine
    run_command "installing the docker engine and cli" \
                "sudo apt-get update -y && \\
                sudo apt-get install -y docker-ce docker-ce-cli \\
                containerd.io docker-compose-plugin"

    # Make sure the docker group exists
    if ! getent group docker > /dev/null 2>&1; then
        run_command "creating the docker group" \
                    "sudo groupadd docker"
    fi

    # Add the current user to the docker group
    run_command "adding the current user to the docker group" \
                "sudo usermod -aG docker $USER"
fi
