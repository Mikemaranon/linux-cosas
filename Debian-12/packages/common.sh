#!/usr/bin/env bash

set -euo pipefail

readonly COMMON_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(cd "${COMMON_DIR}/.." && pwd)"
readonly DEFAULT_EXPORT_DIR="${PROJECT_ROOT}/output/export_$(date +%Y%m%d_%H%M%S)"
readonly LOG_TIMESTAMP="$(date +%Y%m%d_%H%M%S)"

log_info() {
    printf '[INFO] %s\n' "$*"
}

log_warn() {
    printf '[WARN] %s\n' "$*" >&2
}

log_error() {
    printf '[ERROR] %s\n' "$*" >&2
}

ensure_directory() {
    local dir_path="$1"
    mkdir -p "${dir_path}"
}

init_log_file() {
    local log_dir="$1"
    ensure_directory "${log_dir}"
    local log_file="${log_dir}/migration_${LOG_TIMESTAMP}.log"
    exec > >(tee -a "${log_file}") 2>&1
    log_info "Log file: ${log_file}"
}

require_command() {
    local command_name="$1"
    if ! command -v "${command_name}" >/dev/null 2>&1; then
        log_error "Required command not found: ${command_name}"
        return 1
    fi
}

run_step() {
    local step_name="$1"
    shift

    log_info "Starting: ${step_name}"
    if "$@"; then
        log_info "Completed: ${step_name}"
    else
        local exit_code="$?"
        log_error "Failed: ${step_name} (exit code: ${exit_code})"
        return "${exit_code}"
    fi
}

write_metadata() {
    local export_dir="$1"

    cat > "${export_dir}/metadata.env" <<META
EXPORT_CREATED_AT="$(date -Is)"
HOSTNAME="$(hostname)"
CURRENT_USER="${USER}"
KERNEL="$(uname -r)"
ARCH="$(dpkg --print-architecture 2>/dev/null || uname -m)"
META
}

safe_copy_file() {
    local source_file="$1"
    local destination_file="$2"

    if [[ -f "${source_file}" ]]; then
        ensure_directory "$(dirname "${destination_file}")"
        cp -a "${source_file}" "${destination_file}"
        log_info "Copied config: ${source_file}"
    else
        log_warn "Config not found, skipping: ${source_file}"
    fi
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}
