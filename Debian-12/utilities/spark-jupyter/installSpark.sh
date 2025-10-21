#!/bin/bash

cd ~

sudo apt update -y && apt upgrade -y
sudo apt install openjdk-11-jdk -y
sudo apt install python3 -y
sudo apt install python3-venv

sudo wget -N https://dlcdn.apache.org/spark/spark-3.5.5/spark-3.5.5-bin-hadoop3.tgz

sudo tar -xvf spark-3.5.5-bin-hadoop3.tgz
sudo mv spark-3.5.5-bin-hadoop3 /opt/spark
sudo mv /opt/spark/spark-3.5.5-bin-hadoop3/* /opt/spark

# Crear un entorno virtual de Python en /opt/spark
python3 -m venv /opt/spark/spark_venv

# Activar el entorno virtual
source /opt/spark/spark_venv/bin/activate
# Instalar PySpark dentro del entorno virtual
pip install pyspark

cd ~
echo "export SPARK_HOME=/opt/spark" >> ~/bashPrueba.txt
echo "export PATH=\$SPARK_HOME/bin:\$PATH" >> ~/bashPrueba.txt
echo "export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64" >> ~/bashPrueba.txt
echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> ~/bashPrueba.txt

sudo cat ~/bashPrueba.txt >> ~/.bashrc
rm ~/bashPrueba.txt

cd ~/Escritorio/linux-cosas/scripts/spark-jupyter
chmod +x sour.sh
./sour.sh

echo -e "java version: $(java -version) \n python version: $(python3 --version)"
