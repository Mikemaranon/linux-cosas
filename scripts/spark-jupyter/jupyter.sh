#!/bin/bash

sudo systemctl enable ssh
sudo systemctl start ssh


# Crear y activar el entorno virtual si no existe
if [ ! -d "/opt/spark/spark_venv" ]; then
  python3 -m venv /opt/spark/spark_venv
  echo "Entorno virtual creado en /opt/spark/spark_venv"
fi

# Activar el entorno virtual
source /opt/spark/spark_venv/bin/activate

# Instalar las dependencias necesarias dentro del entorno virtual
pip install --upgrade pip

sudo apt install python3-pip -y
pip3 install jupyter-core
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

sudo cat ~/pyspark.txt >> ~/.bashrc
rm ~/pyspark.txt

cd ~/Escritorio/linux-cosas/scripts/spark-jupyter
chmod +x sour.sh
./sour.sh

mkdir -p ~/.ipython/profile_default/startup/
echo "import findspark; findspark.init()" > ~/.ipython/profile_default/startup/00-pyspark-startup.py

pip install toree
jupyter toree install --spark_home=$SPARK_HOME --interpreters=Scala,PySpark

# Comprobar instalación
echo -e "Instalación de Jupyter y PySpark completa"
echo "Verificando versión de Python:"
python3 --version
echo "Verificando versión de Spark:"
$SPARK_HOME/bin/spark-submit --version

