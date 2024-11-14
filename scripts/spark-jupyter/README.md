# INSTALAR SPARK
### clonar repositorio
``` bash
git clone http://github.com/Mikemaranon/linux-cosas.git
cd linux-cosas/scripts/spark-jupyter
```
### dar permisos de ejecución y ejecutar
``` bash
sudo chmod +x installSpark.sh && chmod +x sour.sh
./installSpark.sh
```
### ejecutar source en caso de no tener spark
``` bash
source ~/.bashrc
```
### Iniciar spark
``` bash
# scala
spark-shell
# PySpark
pyspark
# SQL
spark-sql
```
# instalar jupyter
### Ejecutamos script
``` bash
sudo chmod +x jupyter.sh
./jupyter.sh
```
### iniciamos jupyter notebook o jupyter lab
``` bash
jupyter notebook --ip=0.0.0.0 --no-browser --port=8888
jupyter lab --no-browser --port=8888
# en mi caso he usado el puerto 8888, se puede usar el que queramos
```
### ejecutamos el siguiente comando en nuestra MAQUINA LOCAL
``` bash
ssh -L 8888:localhost:8888 $USER@$HOST_IP
# sustituye $USER por usuario de la mv (en mi caso "spark")
# sustituye $HOST_IP por ip de la mv (en mi caso "10.202.0.48")
```
### ejecutamos el siguiente comando en la MAQUINA VIRTUAL
``` bash
jupyter lab --no-browser --port=8888
```
