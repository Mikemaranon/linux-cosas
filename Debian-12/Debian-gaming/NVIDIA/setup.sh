#!/usr/bin/env bash

set -e

# ============================================================
# NVIDIA Driver Auto Installer for Debian 12 (CLI only)
# Assumes NVIDIA GPU is present
# ============================================================

NVIDIA_BASE_URL="https://download.nvidia.com/XFree86/Linux-x86_64"
WORKDIR="/tmp/nvidia-driver-install"

# ------------------------------------------------------------
# Helpers
# ------------------------------------------------------------

log() {
    echo -e "\n[INFO] $1"
}

error() {
    echo -e "\n[ERROR] $1"
    exit 1
}

require_root() {
    if [[ "$EUID" -ne 0 ]]; then
        error "This script must be run as root"
    fi
}

# ------------------------------------------------------------
# GPU detection
# ------------------------------------------------------------

detect_gpu() {
    log "Detecting NVIDIA GPU..."

    GPU_LINE=$(lspci | grep -i nvidia | head -n1 || true)

    if [[ -z "$GPU_LINE" ]]; then
        error "No NVIDIA GPU detected"
    fi

    GPU_NAME=$(echo "$GPU_LINE" | sed 's/.*NVIDIA Corporation //')
    log "Detected GPU: $GPU_NAME"
}

# ------------------------------------------------------------
# Fetch latest driver version
# ------------------------------------------------------------

fetch_latest_driver_version() {
    log "Fetching latest NVIDIA Linux driver version..."

    DRIVER_VERSION=$(curl -fsSL "${NVIDIA_BASE_URL}/latest.txt" | tr -d '\n')

    if [[ -z "$DRIVER_VERSION" ]]; then
        error "Unable to fetch latest driver version"
    fi

    log "Latest driver version: $DRIVER_VERSION"
}

# ------------------------------------------------------------
# Download driver
# ------------------------------------------------------------

download_driver() {
    log "Downloading NVIDIA driver..."

    mkdir -p "$WORKDIR"
    cd "$WORKDIR"

    DRIVER_RUN="NVIDIA-Linux-x86_64-${DRIVER_VERSION}.run"
    DRIVER_URL="${NVIDIA_BASE_URL}/${DRIVER_VERSION}/${DRIVER_RUN}"

    curl -LO "$DRIVER_URL" || error "Driver download failed"
    chmod +x "$DRIVER_RUN"

    log "Driver downloaded: $DRIVER_RUN"
}

# ------------------------------------------------------------
# System preparation
# ------------------------------------------------------------

install_dependencies() {
    log "Installing build dependencies..."

    apt update
    apt install -y linux-headers-amd64 build-essential dkms curl
}

disable_nouveau() {
    log "Disabling Nouveau driver..."

    cat <<EOF >/etc/modprobe.d/blacklist-nouveau.conf
blacklist nouveau
options nouveau modeset=0
EOF

    update-initramfs -u
}

stop_graphical_target() {
    log "Switching to multi-user target (no GUI)..."
    systemctl isolate multi-user.target
}

# ------------------------------------------------------------
# Driver installation
# ------------------------------------------------------------

install_driver() {
    log "Installing NVIDIA driver..."

    cd "$WORKDIR"

    ./NVIDIA-Linux-x86_64-${DRIVER_VERSION}.run \
        --dkms \
        --silent \
        --no-questions \
        --disable-nouveau \
        --no-x-check
}

# ------------------------------------------------------------
# Main
# ------------------------------------------------------------

main() {
    require_root
    detect_gpu
    fetch_latest_driver_version
    install_dependencies
    disable_nouveau

    log "System needs reboot before installation"
    log "Reboot now, then re-run this script to continue"
}

post_reboot() {
    fetch_latest_driver_version
    download_driver
    stop_graphical_target
    install_driver

    log "Installation finished"
    log "Reboot the system and verify with: nvidia-smi"
}

# ------------------------------------------------------------
# Entrypoint
# ------------------------------------------------------------

if [[ "$1" == "--post-reboot" ]]; then
    post_reboot
else
    main
fi
