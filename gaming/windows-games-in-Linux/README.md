# Juegos incompatibles con linux

A pesar de que jugar en linux es algo cada vez más popular (especialmente desde el lanzamiento de la steam deck), aun hay muchos juegos que no soportan de forma nativa su ejecución en linux y usar wine o proton no resulta ser suficiente.
Esto suele estar generalmente causado por los anticheats a nivel de kernel de windows, que por lo general no tienen soporte para linux. Para esto voy a mostrar como poner una máquina virtual a nivel de kernel (lo cual aumenta muchisimo el rendimiento) que acceda a una partición de disco donde tendremos instalados todos los juegos que requieran funcionar en windows, pero pudiendo instalarlos a través de nuestro sistema de linux original.

## 1. Particionar disco para la MV

Necesitamos definir el disco que le vamos a dar a la máquina virtual, por lo que vamos a crear una partición y así la instalación de los juegos será más fácil  
primero comprobamos los bloques del disco y optimizamos
```bash
sudo e2fsck -f -y /dev/sda1
```
Luego una vez tenemos esto, especificamos la cantidad de almacenamiento que queremos particionar para mantener en el disco original.  
En mi caso, como quiero crear una partición de 300GB, voy a reducir el tamaño del disco a lo que quede (931 - 300 = 631GB aprox)

>**IMPORTANTE**  
> Hay que especificar el tamaño en bloques  
> `631GB * 1024 * 1024 / 2 = 165.806.080 bloques`

### 1.1 Dividimos el disco

```bash
sudo resize2fs /dev/sda1 165806080
```
Dependiendo de la cantidad de datos almacenados y el tipo del disco puede tardar hasta una hora.

### 1.2 Montamos de vuelta el disco original

Ahora montamos de vuelta el disco en la ubicación que teníamos (en mi caso `/mnt/discordia`)
```bash
sudo mount /dev/sda1 /mnt/discordia
```

### 1.3 Particiones lógicas con `fdisk`

escribimos en la terminal:
```bash
sudo fdisk /dev/sda
```
nos saldrá un menú, si escribimos `p` nos mostrará la información de nuestro disco:
```bash
Command (m for help): p

Disk /dev/sda: 931.51 GiB, 1000204886016 bytes, 1953525168 sectors
Disk model: TOSHIBA HDWD110 
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: gpt
Disk identifier: 33DDE3E1-F76B-4955-AC93-10BBDB90B505

Device     Start        End    Sectors   Size Type
/dev/sda1   2048 1953523711 1953521664 931.5G Linux filesystem
```

#### 1.3.1 Crear partición lógica 1
Tenemos que escribir esta secuencia de acciones:
```bash
Command (m for help): d
Selected partition 1
Partition 1 has been deleted.

Command (m for help): n
Partition number (1-128, default 1): 1
First sector (34-1953525134, default 2048): 2048
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-1953525134, default 1953523711): +631G

Created a new partition 1 of type 'Linux filesystem' and of size 631 GiB.
Partition #1 contains a ext4 signature.

Do you want to remove the signature? [Y]es/[N]o: n
```

#### 1.3.2 Crear partición lógica 2

Ahora tenemos que escribir esta secuencia de comandos:
```bash
Command (m for help): n
Partition number (2-128, default 2): 2
First sector (1323304960-1953525134, default 1323304960): 
#DALE A ENTER PARA DAR EL TAMAÑO POR DEFECTO QUE ES DONDE EMPIEZA EL ESPACIO SIN ASIGNAR

Last sector, +/-sectors or +/-size{K,M,G,T,P} (1323304960-1953525134, default 1953523711): +300G

Created a new partition 2 of type 'Linux filesystem' and of size 300 GiB.

Command (m for help): 
```

#### 1.3.3 Comprobamos todo

Para eso escribimos `p`:

```bash
Command (m for help): p

Disk /dev/sda: 931.51 GiB, 1000204886016 bytes, 1953525168 sectors
Disk model: TOSHIBA HDWD110 
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: gpt
Disk identifier: 33DDE3E1-F76B-4955-AC93-10BBDB90B505

Device          Start        End    Sectors  Size Type
/dev/sda1        2048 1323304959 1323302912  631G Linux filesystem
/dev/sda2  1323304960 1952450559  629145600  300G Linux filesystem
```
Para salir escribimos `w`

#### 1.3.4 Formateamos `/dev/sda2` a NTFS

Escribimos el siguiente comando:
```bash
sudo mkfs.ntfs -f /dev/sda2

#Salida
mike@LNX-MIKE:/mnt/discordia$ sudo mkfs.ntfs -f /dev/sda2
Cluster size has been automatically set to 4096 bytes.
Creating NTFS volume structures.
mkntfs completed successfully. Have a nice day.
```
## 2. Creacion de la MV de `Windows 11`

