# INSTALAR SPARK Y JUPYTER EN UN SERVIDOR

Este proyecto permite instalar Apache Spark y JupyterLab en un servidor con un entorno virtual, configurarlos para que se inicien automáticamente al arrancar el sistema, y acceder a ellos de manera remota. 

### Estructura del Proyecto:
```sh
.
└── scripts
    └── spark-jupyter
        ├── installSpark.sh   # Script para instalar Spark
        ├── jupyter.sh        # Script para configurar Jupyter
        ├── README.md         # Este archivo
        ├── sour.sh           # Script auxiliar para configurar entorno
        ├── spark_systemd.sh  # Script para crear el servicio systemd
        └── start_spark.sh    # Script para iniciar Spark con el entorno virtual
```
<br></br>

# Instalar Spark
### 1. Clonar el Repositorio
Primero, clona el repositorio en tu servidor:
```bash
git clone http://github.com/Mikemaranon/linux-cosas.git
cd linux-cosas/scripts/spark-jupyter
```
### 2. dar permisos de ejecución y ejecutar

Este script instala `Apache Spark` en tu servidor, crea un entorno virtual para ejecutarlo, y configura las variables de entorno necesarias.
Lo he podido realizar gracias a la ayuda de [Daniel Serrano](https://github.com/VKRVS)  

``` bash
sudo chmod +x installSpark.sh && chmod +x sour.sh
./installSpark.sh
```

### 2. Activar el Entorno Virtual

En caso de que Spark no funcione correctamente, activa el entorno virtual creado en el paso anterior:
```bash
source /opt/spark/spark_venv/bin/activate
```

### 2.1 ejecutar source en caso de no poder lanzar Spark
``` bash
source ~/.bashrc
```
### 3. Iniciar Spark

Una vez completada la instalación, puedes iniciar Spark en diferentes modos:

- **Scala:**
  ```bash
  spark-shell
  ```
- **PySpark:**
  ```bash
  pyspark
  ```
- **SQL:**
  ```bash
  spark-sql
  ```
<br></br>

# INSTALAR JUPYTER
### 1. Damos permisos y ejecutamos script
Este script instala y configura **JupyterLab** y **Jupyter Notebook** en tu servidor para que puedas ejecutarlos de manera remota. Lo he podido realizar gracias a la ayuda de [Hugo Moreno](https://github.com/hugomorenoo) y [Daniel Serrano](https://github.com/VKRVS)
``` bash
sudo chmod +x jupyter.sh
./jupyter.sh
```

### 1.1 Activar el Entorno Virtual en Caso de Problemas

Si no puedes ejecutar Jupyter después de la instalación, ejecuta el siguiente comando para activar las configuraciones necesarias:
```bash
source ~/.bashrc
reboot
```
### 2. Iniciamos jupyter notebook
``` bash
jupyter notebook --ip=0.0.0.0 --no-browser --port=8888
# en mi caso he usado el puerto 8888, se puede usar el que queramos
```
### 3. Ejecutamos el siguiente comando en nuestra MAQUINA LOCAL
``` bash
ssh -L 8889:localhost:8889 $USER@$HOST_IP
# sustituye $USER por usuario de la mv (en mi caso "spark")
# sustituye $HOST_IP por ip de la mv (en mi caso "10.202.0.48")
```
### 4. Iniciar Jupyter Lab en el SERVIDOR

Finalmente, ejecuta Jupyter Lab en la máquina virtual en el mismo puerto:

```bash
jupyter lab --no-browser --port=8889
```
<br></br>

# INICIAR SPARK Y JUPYTER AUTOMÁTICAMENTE AL ARRANCAR EL SISTEMA

Para que Spark y Jupyter se inicien automáticamente al arrancar el sistema, usa el script `spark_systemd.sh` para crear un servicio **Systemd**. Esto garantizará que Spark y Jupyter se inicien sin intervención manual cada vez que se encienda el servidor.

### 1. Crear y Habilitar el Servicio Systemd

Ejecuta el siguiente script para configurar el servicio de **Systemd**:

```bash
sudo chmod +x spark_systemd.sh
./spark_systemd.sh
```

Esto creará un servicio llamado `spark-jupyter.service` que ejecutará Spark y Jupyter automáticamente al arrancar el sistema.

### 2. Verificar el Estado del Servicio

Puedes verificar si el servicio está activo con el siguiente comando:

```bash
sudo systemctl status spark-jupyter.service
```

---

Con estos pasos, tendrás Spark y JupyterLab instalados y configurados en tu servidor, con acceso remoto habilitado y servicio automático al inicio. Si tienes alguna pregunta o problema, no dudes en consultar la documentación o abrir un issue en el repositorio.
