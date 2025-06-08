# Juegos incompatibles con linux

A pesar de que jugar en linux es algo cada vez más popular (especialmente desde el lanzamiento de la steam deck), aun hay muchos juegos que no soportan de forma nativa su ejecución en linux y usar wine o proton no resulta ser suficiente.
Esto suele estar generalmente causado por los anticheats a nivel de kernel de windows, que por lo general no tienen soporte para linux. Para esto voy a mostrar como poner una máquina virtual a nivel de kernel (lo cual aumenta muchisimo el rendimiento) que acceda a una partición de disco donde tendremos instalados todos los juegos que requieran funcionar en windows, pero pudiendo instalarlos a través de nuestro sistema de linux original.

## Requisitos previos

- `CPU Intel` con `VT-x` y `VT-d` activados en BIOS (o AMD con AMD-Vi)
- `32GB RAM` mínimo (recomendado)
- Linux con `KVM` y `QEMU` instalados
- Conexión de red local (loopback localhost suficiente para streaming)
- GPU `NVIDIA RTX 4060 Ti` usada por Linux (no se hace passthrough)

> `WARNING`: 
> He acabado usando Windows 10 en vez de Windows 11 porque la ISO oficial de Windows 11 no me permitía instalar por requisitos mínimos del sistema.

## 1. Instalar dependencias en Linux (host)

```bash
sudo apt update
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager ovmf
sudo systemctl enable --now libvirtd
```

### Crear disco virtual de la VM

En mi caso, voy a hacerlo en mi otro disco duro ubicado en `/mnt/discordia`
- Le damos 80 Gigas de almacenamiento para que no haya problema con el SO y el League of Legends
```bash
qemu-img create -f qcow2 /mnt/discordia/VMs/Win11/windows11.qcow2 80G
```

### Descargar ISO oficial de Windows 11 y preparar

Hay muchas formas de obtener una ISO, desde la página oficial de Microsoft se puede obtener. Si utilizas windows hay un ejecutable que te dan para crear la imagen sin problemas, si utilizas linux o cualquier otro sistema, puedes solicitar una ISO del idioma que quieras abajo del todo
- Descargar desde: https://www.microsoft.com/en-us/software-download/windows11
- Guardar en `/mnt/discordia/VMs/Win11/Win11_24H2_Spanish_x64.iso`

### Script para lanzar VM con QEMU/KVM y VirtIO GPU

Este script es muy largo, vamos a desglosarlo:
- `qemu-system-x86_64`: Ejecuta QEMU para arquitectura x86_64 (64 bits).
- `-enable-kvm`: Activa la aceleración por hardware KVM para mejor performance.
- `-m 12G`: Asigna 12 GB de RAM a la máquina virtual.
- `-cpu host,kvm=on`: Usa la CPU del host con extensiones habilitadas para KVM.
- `-smp 6,sockets=1,cores=6,threads=1`: Configura 6 CPUs virtuales (1 socket, 6 cores, 1 thread).
- `-machine q35,accel=kvm`: Usa la máquina tipo q35 y acelera con KVM.
- `-bios /usr/share/OVMF/OVMF_CODE.fd`: Firmware UEFI necesario para Windows 11.
- `-drive file=~/windows11.qcow2,format=qcow2,if=virtio`: Disco duro virtual con formato qcow2 y controlador VirtIO.
- `-cdrom /mnt/discordia/VMs/Win11/Win11_24H2_Spanish_x64.iso`: Imagen ISO de Windows 11 para instalación.
- `-device virtio-net-pci,netdev=net0`: Adaptador de red VirtIO para mejor rendimiento.
- `-netdev user,id=net0,hostfwd=tcp::2222-:3389`: Red user-mode con mapeo de puerto para RDP (host 2222 a VM 3389).
- `-device virtio-vga`: Tarjeta gráfica virtual VirtIO.
- `-device virtio-balloon-pci`: Dispositivo para ajuste dinámico de memoria (balloon).
- `-usb`: Habilita soporte USB.
- `-device usb-tablet`: Mejor captura de mouse con dispositivo USB tablet.
- `-device ich9-intel-hda -device hda-duplex`: Controladora de audio Intel HD Audio.
- `-device virtio-input-pci`: Dispositivo de entrada VirtIO (mouse y teclado).
- `-monitor stdio`: Consola QEMU interactiva en la terminal.

```bash
qemu-system-x86_64 \
    -enable-kvm \
    -m 12G \
    -cpu host,kvm=on \
    -smp 6,sockets=1,cores=6,threads=1 \
    -machine q35,accel=kvm \
    -bios /usr/share/OVMF/OVMF_CODE.fd \
    -drive file=/mnt/discordia/VMs/Win11/windows11.qcow2,format=qcow2,if=virtio \
    -cdrom /mnt/discordia/VMs/Win11/Win11_24H2_Spanish_x64.iso \
    -device virtio-net-pci,netdev=net0 \
    -netdev user,id=net0,hostfwd=tcp::2222-:3389 \
    -device virtio-vga \
    -device virtio-balloon-pci \
    -usb \
    -device usb-tablet \
    -device ich9-intel-hda -device hda-duplex \
    -device virtio-keyboard-pci \
    -device virtio-mouse-pci \
    -monitor stdio
```

### Instalamos Moonlight en Linux (host)

No he logrado encontrar moonlight en el gestor de `apt`, pero si en el de `snap`

```bash
sudo snap install moonlight
```

## Paso 2: Configurar la Máquina Virtual

Aquí tendremos todas las configuraciones necesarias para nuestra VM de Windows 11

### Instalar drivers VirtIO en Windows 11

- Descargar ISO de drivers VirtIO: https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/virtio-win.iso
- Montar ISO dentro de la VM (desde virt-manager o agregar `-cdrom` en QEMU)
- Instalar drivers para red y almacenamiento dentro de Windows 11

### Instalar Sunshine en Windows 11

- Descargar Sunshine: https://github.com/LizardByte/Sunshine/releases
- Instalar y configurar para que corra al inicio
- Configurar un usuario y contraseña para Moonlight

## Paso 3: Conectar VM con Host 

Con el Host configurado para correr la VM y la VM configurada para ejecutar Sunshine, vamos a conectar ambos para poder controlar la VM desde el host sin necesidad de hacer GPU passthrough

### Emparejar Moonlight con Sunshine

```bash
moonlight pair <IP-VM>
```

> IP-VM puede ser `127.0.0.1` si usamos red local y forward de puertos

### Ejecutar streaming

```bash
moonlight stream <IP-VM>
```

Se abrirá una ventana con la pantalla de la VM y podrás jugar con baja latencia.