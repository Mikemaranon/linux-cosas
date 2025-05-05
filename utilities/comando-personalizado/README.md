# Crear un comando personalizado

Para crear un comando podemos realizar la acción que queramos. En mi caso tengo un servidor debian donde tengo varios servidores instalados y quiero ejecutar un comando que voy a llamar `ports` para que cuando lo llame, me imprima por pantalla el contenido de un fichero llamado `server-ports` que tengo en `/home/mike`.

el contenido de mi fichero es el siguiente:
```bash
╔════════════════════════════════╦═══════════════════════════════╗
║         REMOTE-SERVER          ║        URL CONNECTION         ║
╠════════════════════════════════╬═══════════════════════════════╣
║  minecraft: servidor-1         ║    > [DIRECCION-IP]:25565     ║
╠════════════════════════════════╬═══════════════════════════════╣
║  minecraft: servidor-2         ║    > [DIRECCION-IP]:25564     ║
╠════════════════════════════════╬═══════════════════════════════╣
║  Jupyter-lab                   ║  http://[DIRECCION-IP]:8888   ║
╠════════════════════════════════╬═══════════════════════════════╣
║  vs-code-server                ║  http://[DIRECCION-IP]:8080   ║
╠════════════════════════════════╬═══════════════════════════════╣
```

Para poder hacer esto de forma manual simplemente tendria que hacer lo siguiente:
```bash
cd /home/mike
cat server-ports

# o sin moverme de directorio
cat /home/mike/server-ports
```
el caso es que quiero que esto se realice desde cualquier directorio del sistema sin necesidad de poner la ruta completa, simplemente escribiendo `ports`

## 1: Crear el archivo script

primero ejecutamos este comando
```bash
nano ~/ports
```
Dentro del editor que se va a abrir, escribimos lo siguiente:
```bash
#!/bin/bash
cat /home/mike/server-ports
```
Guardamos el archivo y lo cerramos

## 2: dar permisos de ejecución al script
 
todo script del sistema necesita tener permisos de ejecucion, ya que en su momento de creación no los tiene
```bash
chmod +x ~/ports
```

## 3: Añadir el comando a PATH

realizando esto podremos ejecutar el comando desde donde queramos. Primero vamos a editar `~/.bashrc` con un `echo`
```bash
echo 'export PATH=$PATH:/home/mike' >> ~/.bashrc
```
aplicamos los cambios
```bash
source ~/.bashrc
```

## 4: Listo, ya tenemos el comando `ports`

el resultado sería tal que así:

```bash
mike@LNX-MIKE:~/Escritorio/remote-servers$ ports

╔════════════════════════════════╦═══════════════════════════════╗
║         REMOTE-SERVER          ║        URL CONNECTION         ║
╠════════════════════════════════╬═══════════════════════════════╣
║  minecraft: servidor-1         ║    > [DIRECCION-IP]:25565     ║
╠════════════════════════════════╬═══════════════════════════════╣
║  minecraft: servidor-2         ║    > [DIRECCION-IP]:25564     ║
╠════════════════════════════════╬═══════════════════════════════╣
║  Jupyter-lab                   ║  http://[DIRECCION-IP]:8888   ║
╠════════════════════════════════╬═══════════════════════════════╣
║  vs-code-server                ║  http://[DIRECCION-IP]:8080   ║
╠════════════════════════════════╬═══════════════════════════════╣

mike@LNX-MIKE:~/Escritorio/remote-servers$
```