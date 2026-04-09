#!/usr/bin/env bash

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "${SCRIPT_DIR}/common.sh"

EXPORT_DIR="${1:-${DEFAULT_EXPORT_DIR}}"

export_apt_packages() {
    ensure_directory "${EXPORT_DIR}/apt"

    if ! command_exists apt-mark || ! command_exists dpkg-query; then
        log_error "APT tooling is not available on this system"
        return 1
    fi

    apt-mark showmanual | sort > "${EXPORT_DIR}/apt/apt_manual_packages.txt"
    dpkg-query -W -f='${binary:Package}\t${Version}\n' | sort > "${EXPORT_DIR}/apt/apt_full_package_list.tsv"

    if [[ -f /etc/apt/sources.list ]]; then
        cp -a /etc/apt/sources.list "${EXPORT_DIR}/apt/sources.list"
    fi

    if [[ -d /etc/apt/sources.list.d ]]; then
        cp -a /etc/apt/sources.list.d "${EXPORT_DIR}/apt/sources.list.d"
    fi

    if [[ -d /etc/apt/keyrings ]]; then
        cp -a /etc/apt/keyrings "${EXPORT_DIR}/apt/keyrings"
    fi

    if [[ -d /etc/apt/trusted.gpg.d ]]; then
        cp -a /etc/apt/trusted.gpg.d "${EXPORT_DIR}/apt/trusted.gpg.d"
    fi

    if [[ -f /etc/apt/trusted.gpg ]]; then
        cp -a /etc/apt/trusted.gpg "${EXPORT_DIR}/apt/trusted.gpg"
    fi
}

export_flatpak_state() {
    ensure_directory "${EXPORT_DIR}/flatpak"

    if ! command_exists flatpak; then
        log_warn "Flatpak not found, skipping Flatpak export"
        return 0
    fi

    flatpak remotes --columns=name,url,options > "${EXPORT_DIR}/flatpak/remotes.tsv"
    flatpak list --app --columns=application,branch,origin,installation > "${EXPORT_DIR}/flatpak/apps.tsv"
    flatpak list --runtime --columns=application,branch,origin,installation > "${EXPORT_DIR}/flatpak/runtimes.tsv"
}

export_rust_state() {
    ensure_directory "${EXPORT_DIR}/rust"

    if ! command_exists rustup; then
        log_warn "rustup not found, skipping Rust export"
        return 0
    fi

    rustup show > "${EXPORT_DIR}/rust/rustup_show.txt"
    rustup toolchain list > "${EXPORT_DIR}/rust/toolchains.txt"
    rustup target list --installed > "${EXPORT_DIR}/rust/targets.txt"
    rustup component list --installed > "${EXPORT_DIR}/rust/components.txt"

    if command_exists cargo; then
        cargo install --list > "${EXPORT_DIR}/rust/cargo_install_list.txt"
        awk '/^[^ ]/ {print $1}' "${EXPORT_DIR}/rust/cargo_install_list.txt" | sed 's/v[0-9].*$//' | sort -u > "${EXPORT_DIR}/rust/cargo_installed_crates.txt"
    fi
}

export_python_state() {
    ensure_directory "${EXPORT_DIR}/python"

    if ! command_exists pip3; then
        log_warn "pip3 not found, skipping Python export"
        return 0
    fi

    pip3 list --format=freeze > "${EXPORT_DIR}/python/pip3_global_freeze.txt"
}

export_node_state() {
    ensure_directory "${EXPORT_DIR}/node"

    if ! command_exists npm; then
        log_warn "npm not found, skipping Node export"
        return 0
    fi

    npm list -g --depth=0 --json > "${EXPORT_DIR}/node/npm_global_packages.json"
    npm list -g --depth=0 --parseable | tail -n +2 | xargs -r -n1 basename | sort -u > "${EXPORT_DIR}/node/npm_global_packages.txt"
}

export_user_configuration() {
    ensure_directory "${EXPORT_DIR}/user_config"

    safe_copy_file "${HOME}/.bashrc" "${EXPORT_DIR}/user_config/.bashrc"
    safe_copy_file "${HOME}/.profile" "${EXPORT_DIR}/user_config/.profile"
    safe_copy_file "${HOME}/.zshrc" "${EXPORT_DIR}/user_config/.zshrc"
    safe_copy_file "${HOME}/.gitconfig" "${EXPORT_DIR}/user_config/.gitconfig"
    safe_copy_file "${HOME}/.bash_aliases" "${EXPORT_DIR}/user_config/.bash_aliases"
}

main() {
    ensure_directory "${EXPORT_DIR}"
    init_log_file "${EXPORT_DIR}/logs"

    log_info "Export directory: ${EXPORT_DIR}"
    run_step "Write metadata" write_metadata "${EXPORT_DIR}"
    run_step "Export APT packages and repositories" export_apt_packages
    run_step "Export Flatpak state" export_flatpak_state
    run_step "Export Rust toolchains and cargo packages" export_rust_state
    run_step "Export Python global packages" export_python_state
    run_step "Export Node global packages" export_node_state
    run_step "Export user configuration" export_user_configuration

    log_info "Debian environment export finished successfully"
}

main "$@"
