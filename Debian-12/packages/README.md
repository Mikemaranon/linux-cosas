# Debian to Debian environment migration

This package contains production-oriented Bash scripts to export and restore a Debian userland setup without copying unnecessary junk such as caches, sockets or logs.

## Structure

```text
packages/
├── common.sh
├── export_debian_environment.sh
└── restore_debian_environment.sh
```

## What is exported

- APT manual package list
- Full APT package inventory with versions
- APT repositories and keyrings
- Flatpak remotes, apps and runtimes
- Rust toolchains, targets and installed components
- Cargo installed crates
- Global pip3 packages
- Global npm packages
- User dotfiles:
  - `.bashrc`
  - `.profile`
  - `.zshrc`
  - `.gitconfig`
  - `.bash_aliases` if present

## What is intentionally not copied

- Cache directories
- Socket files
- Logs
- Heavy user data unrelated to environment reconstruction

## Usage

### Export

```bash
chmod +x packages/*.sh
./packages/export_debian_environment.sh
./packages/export_debian_environment.sh /path/to/export_dir
```

### Restore

```bash
chmod +x packages/*.sh
./packages/restore_debian_environment.sh /path/to/export_dir
```

## Recommended restore order

The restore script already enforces the correct order:

1. Restore APT repositories and keys
2. Install APT packages
3. Restore Flatpak remotes and apps
4. Restore Rust state
5. Restore Python global packages
6. Restore Node global packages
7. Restore shell and Git configuration

## Notes

- The restore script assumes required base tools such as `flatpak`, `rustup`, `pip3`, and `npm` already exist when restoring those layers.
- For a fresh machine, install those base runtimes first if they are not present.
- Logs are written automatically into the export folder.
