# cursor-server

con este script podemos instalar cursor-server en nuestro servidor para acceder de forma remota tanto con vscode como con cursor desde nuestro equipo local. viene muy bien para utilizar las funcionalidades que ofrece la IA de cursor pudiendo trabajar de forma remota (igual que con code-server).

## 1: actualizamos e instalamos `curl`
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl
```

## 2: instalamos npm y node.js
```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash -
sudo apt install -y nodejs
```
si queremos verificar la instalación:
```bash
node -v
npm -v
```

## 3: Instalar cursor-server
```bash
npm install -g cursor-server
```
para ejecutarlo (recomiendo usar `screen`):
```bash
cursor-server --port 8080 --host 0.0.0.0
```
verificamos que esta corriendo:
```bash
ps aux | grep cursor-server
```

# 4 (solo para clientes de vscode): Instalar la extensión de cursor en VScode

el repositorio oficial de la extensión puedes encontrarlo (aquí)[https://github.com/Helixform/CodeCursor?utm_source=chatgpt.com], no es una extensión oficial desarrollada por cursor, pero sirve para conectar al cursor-server.  
Una vez ahí, iniciamos sesión y conectamos con el servidor


