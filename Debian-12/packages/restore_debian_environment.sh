#!/usr/bin/env bash

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "${SCRIPT_DIR}/common.sh"

readonly EXPORT_DIR="${1:?Usage: restore_debian_environment.sh <export_dir>}"
readonly RESTORE_HOME="${HOME}"

copy_apt_sources() {
    if [[ ! -d "${EXPORT_DIR}/apt" ]]; then
        log_warn "APT export data not found, skipping APT source restoration"
        return 0
    fi

    if [[ -f "${EXPORT_DIR}/apt/sources.list" ]]; then
        sudo cp -a "${EXPORT_DIR}/apt/sources.list" /etc/apt/sources.list
    fi

    if [[ -d "${EXPORT_DIR}/apt/sources.list.d" ]]; then
        sudo mkdir -p /etc/apt/sources.list.d
        sudo cp -a "${EXPORT_DIR}/apt/sources.list.d/." /etc/apt/sources.list.d/
    fi

    if [[ -d "${EXPORT_DIR}/apt/keyrings" ]]; then
        sudo mkdir -p /etc/apt/keyrings
        sudo cp -a "${EXPORT_DIR}/apt/keyrings/." /etc/apt/keyrings/
    fi

    if [[ -d "${EXPORT_DIR}/apt/trusted.gpg.d" ]]; then
        sudo mkdir -p /etc/apt/trusted.gpg.d
        sudo cp -a "${EXPORT_DIR}/apt/trusted.gpg.d/." /etc/apt/trusted.gpg.d/
    fi

    if [[ -f "${EXPORT_DIR}/apt/trusted.gpg" ]]; then
        sudo cp -a "${EXPORT_DIR}/apt/trusted.gpg" /etc/apt/trusted.gpg
    fi
}

restore_apt_packages() {
    local manual_package_file="${EXPORT_DIR}/apt/apt_manual_packages.txt"

    if [[ ! -f "${manual_package_file}" ]]; then
        log_warn "APT manual package list not found, skipping APT package restore"
        return 0
    fi

    sudo apt-get update
    xargs -r sudo apt-get install -y < "${manual_package_file}"
}

restore_flatpak() {
    local remotes_file="${EXPORT_DIR}/flatpak/remotes.tsv"
    local apps_file="${EXPORT_DIR}/flatpak/apps.tsv"

    if ! command_exists flatpak; then
        log_warn "Flatpak is not installed, skipping Flatpak restore"
        return 0
    fi

    if [[ -f "${remotes_file}" ]]; then
        while IFS=$'\t' read -r name url options; do
            [[ -z "${name}" || "${name}" == "Name" ]] && continue
            if ! flatpak remote-list --columns=name | grep -Fxq "${name}"; then
                flatpak remote-add --if-not-exists "${name}" "${url}"
            fi
        done < "${remotes_file}"
    fi

    if [[ -f "${apps_file}" ]]; then
        while IFS=$'\t' read -r application branch origin installation; do
            [[ -z "${application}" || "${application}" == "Application ID" ]] && continue
            flatpak install -y "${origin}" "${application}" "${branch}"
        done < "${apps_file}"
    fi
}

restore_rust() {
    local toolchains_file="${EXPORT_DIR}/rust/toolchains.txt"
    local targets_file="${EXPORT_DIR}/rust/targets.txt"
    local components_file="${EXPORT_DIR}/rust/components.txt"
    local cargo_packages_file="${EXPORT_DIR}/rust/cargo_installed_crates.txt"

    if ! command_exists rustup; then
        log_warn "rustup is not installed, skipping Rust restore"
        return 0
    fi

    if [[ -f "${toolchains_file}" ]]; then
        while IFS= read -r toolchain; do
            [[ -z "${toolchain}" ]] && continue
            rustup toolchain install "${toolchain%% *}"
        done < "${toolchains_file}"
    fi

    if [[ -f "${targets_file}" ]]; then
        while IFS= read -r target; do
            [[ -z "${target}" ]] && continue
            rustup target add "${target}"
        done < "${targets_file}"
    fi

    if [[ -f "${components_file}" ]]; then
        while IFS= read -r component_line; do
            [[ -z "${component_line}" ]] && continue
            local component_name
            component_name="$(awk '{print $1}' <<< "${component_line}")"
            local component_toolchain
            component_toolchain="$(sed -n 's/.*(installed) *//p' <<< "${component_line}")"

            if [[ -n "${component_toolchain}" ]]; then
                rustup component add "${component_name}" --toolchain "${component_toolchain}"
            fi
        done < "${components_file}"
    fi

    if [[ -f "${cargo_packages_file}" ]] && command_exists cargo; then
        while IFS= read -r crate_name; do
            [[ -z "${crate_name}" ]] && continue
            cargo install "${crate_name}" || log_warn "Cargo install failed for ${crate_name}"
        done < "${cargo_packages_file}"
    fi
}

restore_python_packages() {
    local pip_file="${EXPORT_DIR}/python/pip3_global_freeze.txt"

    if [[ ! -f "${pip_file}" ]]; then
        log_warn "pip3 export file not found, skipping Python package restore"
        return 0
    fi

    if ! command_exists pip3; then
        log_warn "pip3 is not installed, skipping Python package restore"
        return 0
    fi

    pip3 install -r "${pip_file}"
}

restore_node_packages() {
    local npm_file="${EXPORT_DIR}/node/npm_global_packages.txt"

    if [[ ! -f "${npm_file}" ]]; then
        log_warn "npm export file not found, skipping Node package restore"
        return 0
    fi

    if ! command_exists npm; then
        log_warn "npm is not installed, skipping Node package restore"
        return 0
    fi

    while IFS= read -r package_name; do
        [[ -z "${package_name}" ]] && continue
        npm install -g "${package_name}"
    done < "${npm_file}"
}

restore_user_configuration() {
    local config_dir="${EXPORT_DIR}/user_config"

    if [[ ! -d "${config_dir}" ]]; then
        log_warn "User config directory not found, skipping config restore"
        return 0
    fi

    safe_copy_file "${config_dir}/.bashrc" "${RESTORE_HOME}/.bashrc"
    safe_copy_file "${config_dir}/.profile" "${RESTORE_HOME}/.profile"
    safe_copy_file "${config_dir}/.zshrc" "${RESTORE_HOME}/.zshrc"
    safe_copy_file "${config_dir}/.gitconfig" "${RESTORE_HOME}/.gitconfig"
    safe_copy_file "${config_dir}/.bash_aliases" "${RESTORE_HOME}/.bash_aliases"
}

main() {
    if [[ ! -d "${EXPORT_DIR}" ]]; then
        log_error "Export directory does not exist: ${EXPORT_DIR}"
        exit 1
    fi

    init_log_file "${EXPORT_DIR}/restore_logs"
    log_info "Using export directory: ${EXPORT_DIR}"

    run_step "Restore APT repositories and keys" copy_apt_sources
    run_step "Restore APT packages" restore_apt_packages
    run_step "Restore Flatpak apps and remotes" restore_flatpak
    run_step "Restore Rust toolchains and cargo packages" restore_rust
    run_step "Restore Python global packages" restore_python_packages
    run_step "Restore Node global packages" restore_node_packages
    run_step "Restore user configuration" restore_user_configuration

    log_info "Debian environment restore finished successfully"
}

main "$@"
