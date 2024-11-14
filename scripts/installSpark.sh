#!/bin/bash

cd ~

sudo apt update -y && apt upgrade -y
sudo apt install openjdk-8-jdk -y
sudo apt install python3 -y

sudo wget -N https://downloads.apache.org/spark/spark-3.5.3/spark-3.5.3-bin-hadoop3.tgz
sudo tar -xvf spark-3.5.3-bin-hadoop3.tgz
sudo mv spark-3.5.3-bin-hadoop3 /opt/spark
sudo mv /opt/spark/spark-3.5.3-bin-hadoop3/* /opt/spark

cd ~
sudo echo "export SPARK_HOME=/opt/spark" >> ~/bashPrueba.txt
sudo echo "export PATH=\$SPARK_HOME/bin:\$PATH" >> ~/bashPrueba.txt
sudo echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> ~/bashPrueba.txt
sudo echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> ~/bashPrueba.txt

sudo cat ~/bashPrueba.txt >> ~/.bashrc
source ~/.bashrc
rm ~/bashPrueba.txt

echo -e "java version: $(java -version) \n python version: $(python3 --version)"
