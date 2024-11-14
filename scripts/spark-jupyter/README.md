# Pasos
### clonar repositorio
``` bash
git clone http://github.com/Mikemaranon/linux-cosas.git
cd linux-cosas/scripts
```
### dar permisos de ejecución
``` bash
sudo chmod +x installSpark.sh
sudo chmod +x sour.sh
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
### instalamos jupyter
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
