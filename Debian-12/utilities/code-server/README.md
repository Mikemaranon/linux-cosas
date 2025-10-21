# code-server para programar desde el navedador

Visual Studio Code es una herramienta muy util para programar, pero el servidor oficial que nos proporciona microsoft no funciona correctamente si accedemos desde un navegador. es por eso que hago esta seccion del repositorio, para mostrar una versión que se puede descargar desde `node.js` con la cual tenemos la funcionalidad practicamente completa de vscode accediendo desde un navegador.

toda la información ha sido obtenida de [este video](https://youtu.be/11YfaGi0Fpk?si=7_eG2TEFgyQKihK9)

## 1: instalar `nodejs 22.x`

lo primero que necesitamos hacer es identificar el repositorio desde el cual vamos a instalar nodejs en su versión 22 (la cual es necesaria para poder instalar code-server):
```bash
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
```
una vez hecho, instalamos `nodejs`
```bash
sudo apt install nodejs  -y
```
con esto nos vendrá el gestor de paquetes oficial de nodejs: `npm`  
Comprobamos las versiones:
```bash
node -v
npm -v
```

## 2. Instalamos `code-server` desde yarn

utilizando yarn, instalamos el servidor, una vez instalado, lo ejecutamos para que se generen los ficheros:
```bash
# Instalamos
yarn global add code-server

# Iniciamos
~/.yarn/bin/code-server
```
Una vez hecho, lo cerramos (CTR + C) y accedemos al fichero de configuración para poder editar la IP y contraseña:
```bash
nano ~/.config/code-server/config.yaml
```
El formato que tiene es este. Necesitamos poner la direccion `0.0.0.0:8080` para que escuche en todas las direcciones y la contraseña entre comillas (si es numérica también):
```bash
bind-addr: 0.0.0.0:8080
auth: password
password: `1234`
cert: false
```
si no queremos contraseña de acceso ponemos el valor de auth a `none`

Iniciamos de nuevo code-server para ver que funciona con este comando:
```bash
~/.yarn/bin/code-server
```

## 3. (OPCIONAL) creamos comando de ejecución

Si no queremos escribir el comando de inicio siempre, podemos definir uno en `.basrc` de la siguiente forma:

```bash
# Ejecutamos
nano ~/.bashrc

# Escribimos al final del fichero
code-server() {
    echo "Starting code-server at http://[SERVER-IP]:[SERVER-PORT]"
    "$HOME/.yarn/bin/code-server" "$@"
}
```
luego guardamos y actualizamos el fichero:
```bash
source ~/.bashrc
```