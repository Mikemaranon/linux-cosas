# INSTALAR SPARK
### 1. clonar repositorio
``` bash
git clone http://github.com/Mikemaranon/linux-cosas.git
cd linux-cosas/scripts/spark-jupyter
```
### 2. dar permisos de ejecución y ejecutar
``` bash
sudo chmod +x installSpark.sh && chmod +x sour.sh
./installSpark.sh
# este script lo he podido realizar gracias a la ayuda de
# - Daniel Serrano: https://github.com/VKRVS
```
### 2.1 ejecutar source en caso de no poder lanzar Spark
``` bash
source ~/.bashrc
```
### 3. Iniciar spark
``` bash
# scala
spark-shell
# PySpark
pyspark
# SQL
spark-sql
```
# instalar jupyter
### 1. Damos permisos y ejecutamos script
``` bash
sudo chmod +x jupyter.sh
./jupyter.sh
# este script lo he podido realizar gracias a la ayuda de
# - Hugo Moreno: https://github.com/hugomorenoo
# - Daniel Serrano: https://github.com/VKRVS
```
### 1.1 ejecutar source en caso de no poder lanzar jupyter notebook
``` bash, luego reiniciamos
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
### 4. Ejecutamos el siguiente comando en la MAQUINA VIRTUAL
``` bash
jupyter lab --no-browser --port=8889
```
