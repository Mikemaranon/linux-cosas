# TP-Link UB500 Bluetooth Setup on Debian 12

## System Information
- OS: Debian 12 (Bookworm)
- Bluetooth Dongle: TP-Link UB500 (Realtek RTL8761B)

---

## Issue
- Bluetooth service is running, but no controller is available:
```bash
No default controller available
```
- Common cause: missing Realtek firmware for the TP-Link UB500 (RTL8761B).

---

## Solution

Debian 12 includes the required Realtek firmware in the **`firmware-realtek`** package, so no manual downloading of firmware blobs is necessary.

### 1. Install Required Packages

```bash
sudo apt update
sudo apt install -y firmware-realtek bluez blueman
```

This package will automatically install the RTL8761B firmware in the appropriate directory.

### 2. Reboot the System

After installing the package, reboot to ensure the firmware is properly loaded:
```bash
sudo reboot
```

### 3. Verify Bluetooth Controller

After rebooting, run the following command to check if the Bluetooth controller is now available:
```bash
bluetoothctl list
```

You should see something like:
```bash
Controller XX:XX:XX:XX:XX:XX MIKE-LNX [default]
```

If the controller shows up, Bluetooth is ready for use.