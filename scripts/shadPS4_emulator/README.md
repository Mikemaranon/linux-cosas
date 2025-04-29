# Build shadPS4 for Linux

Este README está hecho con el contenido del `repositorio oficial` del emulador [ShadPS4](https://github.com/shadps4-emu/shadPS4)
Aquí pondré todo el código y el proceso que me ha servido a mi para poder instalar el emulador en `Debian 12`

## Instalación de dependencias

primero de todo necesitamos instalar todos estos paquetes
```bash
sudo apt install build-essential clang git cmake libasound2-dev \
    libpulse-dev libopenal-dev libssl-dev zlib1g-dev libedit-dev \
    libudev-dev libevdev-dev libsdl2-dev libjack-dev libsndio-dev \
    qt6-base-dev qt6-tools-dev qt6-multimedia-dev libvulkan-dev \
    vulkan-validationlayers libpng-dev
```

luego clonamos el repositorio oficial 
```bash

git clone --recursive https://github.com/shadps4-emu/shadPS4.git
cd shadPS4
```
### troubleshooting

me he encontrado con problemas en la construcción (el siguiente paso) los cuales he resuelto actualizando `gcc` a la versión 13 necesitando añadir el repositorio testing al sistema:
```bash
sudo nano /etc/apt/sources.list
# debes añadir 'testing' a la lista de repositorios tal que así:
# deb http://deb.debian.org/debian testing main
```
luego ya actualizamos la lista de paquetes:
```bash
sudo apt update
```

una vez hemos actualizado el sistema, instalamos `g++-13`:
```bash
sudo apt install -t testing g++-13
```

## Constructor mediante terminal

vamos a generar el directorio de construcción dentro del propio directorio del repositorio que hemos clonado
```bash
cmake -S . -B build/ -DENABLE_QT_GUI=ON -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++
```
Ahora usamos `cmake` para construir el propio proyecto
```bash

```

> Si se te congela el equipo durante la construcción, el repositorio oficial alerta que puede ser por un alto uso de recursos, en tal caso ejecutad el comando anterior sin el parametro `--parallel$(nproc)`

Una vez se haya terminado de montar, ejecutamos el emulador
```bash
./build/shadps4
```
si la ruta donde tenemos los juegos es otra, lo ejecutamos de esta forma:
```bash
./build/shadps4 /"PATH"/"TO"/"GAME"/"FOLDER"/eboot.bin
```