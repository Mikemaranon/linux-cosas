# VNC (Virtual Network Computing)

VNC es un protocolo popular que te permite controlar un escritorio remotamente. Necesitarás instalar un servidor VNC en tu servidor GNOME y un cliente VNC en tu máquina local.

## servidor GNOME:

**Instala un servidor VNC**.  
Puedes usar tightvncserver, x11vnc o vino (el servidor VNC integrado de GNOME). Por ejemplo, para instalar `tightvncserver`:
```Bash
sudo apt update
sudo apt install tightvncserver
```
**Configura el servidor VNC.**
- Para `tightvncserver`, ejecuta `vncserver` por primera vez. Te pedirá que establezcas una contraseña. Luego, puedes configurar la resolución y otras opciones. Los archivos de configuración suelen estar en `~/.vnc/`.  
- Para `x11vnc`, generalmente lo ejecutas para compartir la sesión de X existente: `x11vnc -display :0 -auth guess`.
- Para `vino`, puedes configurarlo a través de la aplicación "Compartir escritorio" en la configuración de GNOME. Asegúrate de habilitar "Permitir que otros vean tu escritorio" y configura una contraseña.

**Abre el puerto en el firewall (si es necesario)**  
El puerto predeterminado para VNC es el 5900. Si tienes un firewall activo (como ufw), necesitas permitir las conexiones a este puerto:
```Bash
sudo ufw allow 5900
```
## Máquina local

**Instala un cliente VNC**  
Hay muchos clientes VNC disponibles para diferentes sistemas operativos (RealVNC Viewer, TigerVNC Viewer, etc.).  

**Conéctate al servidor**   
Abre el cliente VNC e introduce la dirección IP de tu servidor seguida del número de puerto (por ejemplo, 192.168.1.100:5900). Ingresa la contraseña que configuraste en el servidor.