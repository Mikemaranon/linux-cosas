#!/bin/bash

sudo systemctl enable ssh
sudo systemctl start ssh

sudo apt install python3-pip -y
sudo apt install jupyter-core -y
sudo apt install openssh-server -y
pip3 install jupyterlab
pip3 install notebook

pip install findspark
cd ~
echo "export SPARK_HOME=/opt/spark" >> pyspark.txt
echo "export PATH=\$SPARK_HOME/bin:\$PATH" >> pyspark.txt
echo "export PYTHONPATH=\$SPARK_HOME/python:\$PYTHONPATH" >> pyspark.txt
echo "export PYSPARK_PYTHON=python3" >> pyspark.txt

sudo cat ~/bashPrueba.txt >> ~/.bashrc
rm ~/bashPrueba.txt

cd ~/linux-cosas/scripts/spark-jupyter
chmod +x sour.sh
./sour.sh

mkdir -p ~/.ipython/profile_default/startup/
echo "import findspark; findspark.init()" > ~/.ipython/profile_default/startup/00-pyspark-startup.py

pip install toree
jupyter toree install --spark_home=$SPARK_HOME --interpreters=Scala,PySpark


