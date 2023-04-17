#!/bin/bash

# Install docker
# Check if the package manager is dnf, which is used by Fedora and Red Hat
if command -v dnf >/dev/null 2>&1; then
  # Install docker and bridge-utils using dnf
  sudo dnf -y install docker bridge-utils
# If dnf is not available, check if the package manager is yum, which is used by some Linux distributions such as CentOS
elif command -v yum >/dev/null 2>&1; then
  # Install docker and bridge-utils using yum
  sudo yum -y install docker bridge-utils
# If yum is not available, check if the package manager is apt-get, which is used by Debian and Ubuntu
elif command -v apt-get >/dev/null 2>&1; then
  # Update the package manager and install docker and bridge-utils using apt-get
  sudo apt-get update
  sudo apt-get -y install docker.io
  sudo apt-get -y install bridge-utils
# If apt-get is not available, check if the package manager is zypper, which is used by openSUSE
elif command -v zypper >/dev/null 2>&1; then
  # Install docker and bridge-utils using zypper
  sudo zypper install -y docker bridge-utils
# If none of the package managers are available, display an error message and exit
else
  echo "Unsupported package manager, please install docker manually."
  exit 1
fi

# Start and enable the docker service
sudo systemctl start docker
sudo systemctl enable docker

# Stop and disable the firewalld service, if it is running
sudo systemctl stop firewalld
sudo systemctl disable firewalld

# Install containerlab
# Download and execute the containerlab installation script
bash -c "$(wget -qO- https://get.containerlab.dev)" -- -v 0.25.1

# Install go
# Check if the package manager is dnf
if command -v dnf >/dev/null 2>&1; then
  # Update the package manager using dnf
  sudo dnf update -y
# If dnf is not available, check if the package manager is yum
elif command -v yum >/dev/null 2>&1; then
  # Update the package manager using yum
  sudo yum update -y
# If yum is not available, check if the package manager is apt-get
elif command -v apt-get >/dev/null 2>&1; then
  # Update the package manager using apt-get
  sudo apt-get update
# If apt-get is not available, check if the package manager is zypper
elif command -v zypper >/dev/null 2>&1; then
  # Refresh the package manager using zypper
  sudo zypper refresh
fi

# Download and extract the Go binary distribution
curl -LO https://golang.org/dl/go1.17.8.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.17.8.linux-amd64.tar.gz

# Add the Go binary directory to the system path
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc

# Verify that Go is installed and working
go version

# Install kubectl
# Download the latest stable version of kubectl for Linux
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt

