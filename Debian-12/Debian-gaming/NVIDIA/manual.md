# NVIDIA RTX 4060 on Debian 12 (CLI install, no GUI)

## Context
System without graphical environment due to NVIDIA driver issues.
Target GPU: **NVIDIA RTX 4060**
OS: **Debian 12 (Bookworm)**
Driver installed manually using NVIDIA official `.run` installer.

Driver version:
- **580.119.02**
- Release date: 2025-12-11

---

## 1. Download NVIDIA driver via CLI

Using `wget`:

```bash
wget https://us.download.nvidia.com/XFree86/Linux-x86_64/580.119.02/NVIDIA-Linux-x86_64-580.119.02.run
```
or `curl`

```bash
curl -LO https://us.download.nvidia.com/XFree86/Linux-x86_64/580.119.02/NVIDIA-Linux-x86_64-580.119.02.run
```

verify download:
```bash
ls -lh NVIDIA-Linux-x86_64-580.119.02.run
```

## 2. Install required build dependencies

Required for kernel module compilation and DKMS:

```bash
sudo apt update
sudo apt install -y linux-headers-amd64 build-essential dkms
```

## 3. Disable Nouveau driver (mandatory)

Create blacklist file:

```bash
echo -e "blacklist nouveau\noptions nouveau modeset=0" | sudo tee /etc/modprobe.d/blacklist-nouveau.conf
```

Regenerate initramfs:

```bash
sudo update-initramfs -u
sudo reboot
```

After reboot, log in via TTY (Ctrl + Alt + F2).

## 4. Stop graphical environment

Ensure no X / Wayland session is running:

```bash
sudo systemctl isolate multi-user.target
```

## 5. Install NVIDIA driver

Make installer executable:

```bash
chmod +x NVIDIA-Linux-x86_64-580.119.02.run
```

Run installer:
```bash
sudo ./NVIDIA-Linux-x86_64-580.119.02.run
```

Installer options:

- DKMS support: YES
- Compile kernel module: YES
- 32-bit compatibility libs: optional
- Secure Boot signing: NO (Secure Boot disabled in UEFI)

## 6. Reboot system
```bash
sudo reboot
```

## 7. Verify installation
```bash
nvidia-smi
```

Expected result:
```bash
NVIDIA RTX 4060 detected

Driver version 580.119.02

No errors

GNOME should now start correctly with proper resolution.
```

# Notes

Secure Boot must be disabled in UEFI, otherwise the NVIDIA kernel module will not load.
Manual .run installation is preferred when:
- System has no GUI
- Distro packages are outdated
- Immediate support for latest GPUs is required