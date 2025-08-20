#!/bin/bash
# ProTek v999 - Installation Script
# Author: Fervv268
# Version: v999

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROTEK_VERSION="v999"
LOG_DIR="logs"
LOG_FILE="$LOG_DIR/protek_build_$(date +%Y-%m-%d-%H-%M-%S).log"
REQUIRED_ARCH="x86_64"

# Create logs directory
mkdir -p "$LOG_DIR"

# Logging function
log() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

# Header
echo -e "${GREEN}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║               ProTek $PROTEK_VERSION - Installation              ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════╝${NC}"

log "Starting installation: $(date)"
log "User: $(whoami)"
log "Log file: $LOG_FILE"

# Check system architecture
log "Checking system environment..."
ARCH=$(uname -m)
log "Detected architecture: $ARCH"

if [[ "$ARCH" != "$REQUIRED_ARCH" ]]; then
    log_error "Unsupported architecture: $ARCH. Required: $REQUIRED_ARCH"
    exit 1
fi

# Check operating system
if [[ ! -f /etc/os-release ]]; then
    log_warning "Cannot detect OS. This script is optimized for Ubuntu/Debian."
else
    source /etc/os-release
    log "Detected OS: $NAME $VERSION"
fi

# Check if running with sufficient privileges
if [[ $EUID -eq 0 ]]; then
    log_warning "Running as root. Consider using a regular user with sudo access."
fi

# Install system dependencies
log "Installing system dependencies..."

# Check if apt is available
if command -v apt &> /dev/null; then
    log "Updating package repositories..."
    if sudo apt update &>> "$LOG_FILE"; then
        log_success "Package repositories updated"
    else
        log_warning "Failed to update package repositories"
    fi
    
    log "Installing required packages..."
    sudo apt install -y curl wget git &>> "$LOG_FILE"
else
    log_warning "apt package manager not found. Manual installation may be required."
fi

# Check Docker installation
log "Checking Docker installation..."
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version)
    log "Docker found: $DOCKER_VERSION"
else
    log "Docker not found. Installing..."
    
    # Install Docker
    if curl -fsSL https://get.docker.com -o get-docker.sh &>> "$LOG_FILE"; then
        sudo sh get-docker.sh &>> "$LOG_FILE"
        sudo usermod -aG docker "$USER" &>> "$LOG_FILE"
        rm get-docker.sh
        log_success "Docker installed successfully"
        log_warning "Please log out and log back in to apply Docker group membership"
    else
        log_error "Failed to install Docker"
        exit 1
    fi
fi

# Pull required Docker images
log "Pulling required Docker images..."
if docker pull ghcr.io/railwayapp-templates/postgres-ssl:latest &>> "$LOG_FILE"; then
    log_success "Docker images pulled successfully"
else
    log_error "Failed to pull Docker images"
    exit 1
fi

# Set up configuration
log "Setting up configuration..."
if [[ -f "config/docker.conf" ]]; then
    source config/docker.conf
    log "Configuration loaded from config/docker.conf"
fi

# Final status
log_success "ProTek $PROTEK_VERSION installation completed successfully!"
log "Installation finished: $(date)"

echo
echo -e "${GREEN}🎉 ProTek $PROTEK_VERSION is ready to use!${NC}"
echo -e "${BLUE}📚 Check docs/INSTALLATION.md for more information${NC}"
echo -e "${BLUE}📋 Logs saved to: $LOG_FILE${NC}"