# Instalación de drivers de nvidia en debian
me he encontrado muchos problemas a la hora de instalar los drivers adecuados, por lo que para eso hago este repo.

## paso 1: actualizar `/etc/apt/sources.list`
hay que añadir los parámetros `contrib` y `non-free` a los enlaces:
```bash
sudo nano /etc/apt/sourcers.list
```
el resultado de las lineas debería ser tal que asi:
```bash
deb http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
deb-src http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
```

## paso 2: instalar drivers genéricos
se puede probar a instalar los drivers genéricos `nvidia-drivers`
```bash
sudo apt update
sudo apt upgrade
sudo apt install nvidia-drivers
```
comprobamos el estado de los drivers
```bash
nvidia-smi
```
si no nos detecta el comando significa que no se han instalado bien, mi alternativa esta propuesta en el paso 5
## paso 3: instalar CUDA
agregamos el repositorio de CUDA a las fuentes e instalamos el paquete
```bash
wget https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt-get update
sudo apt-get -y install cuda-toolkit-12-8
```
estos comandos los he obtenido de la página oficial de (CUDA)[https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Debian&target_version=12&target_type=deb_network]

## paso 4: Instalar los drivers oficiales específicos
en el caso de que los drivers genéricos no funcionen, podemos ir a la (página oficial de nvidia)[https://us.download.nvidia.com/XFree86/Linux-x86_64/570.133.07/NVIDIA-Linux-x86_64-570.133.07.run] y buscar nuestra gráfica en el sistema que usamos.

lo descargamos y, tras haberlo descargado, lo ejecutamos:
```bash
wget https://us.download.nvidia.com/XFree86/Linux-x86_64/570.133.07/NVIDIA-Linux-x86_64-570.133.07.run
sudo sh NVIDIA-Linux-x86_64-570.133.07.run
```

