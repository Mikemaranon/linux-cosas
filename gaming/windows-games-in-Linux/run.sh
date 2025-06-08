#!/bin/bash

# Ruta al disco duro
# MODIFICAR RUTA PARA TU ENTORNO
DISCORDIA_PATH="/mnt/discordia/VMs/Win11"

# Ruta al disco virtual
DISK_PATH="$DISCORDIA_PATH/windows11.qcow2"

# Ruta a la ISO para instalación (podés comentar esta línea después de instalar)
ISO_PATH="$DISCORDIA_PATH/Win10.iso"

# Ruta para drivers de red
NET_PATH="$DISCORDIA_PATH/virtio-win.iso"

# Ruta al firmware OVMF (UEFI)
OVMF_CODE="/usr/share/OVMF/OVMF_CODE.fd"

# Ejecutar QEMU con aceleración KVM y configuración para Windows 11
qemu-system-x86_64 \
    -enable-kvm \
    -m 12G \
    -cpu host,kvm=on \
    -smp 6,sockets=1,cores=6,threads=1 \
    -machine q35,accel=kvm \
    -bios "$OVMF_CODE" \
    -drive file="$DISK_PATH",format=qcow2,if=ide \
    -drive file="$ISO_PATH",media=cdrom,index=2 \
    -drive file="$NET_PATH",media=cdrom,index=3 \
    -device virtio-net-pci,netdev=net0 \
    -netdev user,id=net0,hostfwd=tcp::2222-:3389,hostfwd=tcp::47984-:47984 \
    -device virtio-vga \
    -device virtio-balloon-pci \
    -usb \
    -device usb-tablet \
    -device ich9-intel-hda -device hda-duplex \
    -device virtio-keyboard-pci \
    -device virtio-mouse-pci \
    -monitor stdio \
    -display none       # ESTO ES SOLO SI NO QUIERES QUE APAREZCA LA VENTANA DE QEMU

