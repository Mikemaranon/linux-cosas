#!/bin/bash
# Agrega el repositorio oficial de Steam

echo "deb [arch=amd64] https://repo.steampowered.com/steam/ stable steam" | sudo tee /etc/apt/sources.list.d/steam.list
wget -qO - https://repo.steampowered.com/steam/archive/stable/steam.gpg | sudo tee /usr/share/keyrings/steam.gpg
sudo apt update
sudo apt install steam -y

# Ejecutar con parámetros para evitar conflictos
STEAM_RUNTIME_PREFER_HOST_LIBRARIES=0 steam
# En caso de errores, intentar:
STEAM_RUNTIME=0 steam
steam --reset
__GLVND_DISALLOW_PATCHING=1 steam
EOF