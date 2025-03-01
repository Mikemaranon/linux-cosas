#!/bin/bash

# Activar el entorno virtual de Spark
source /opt/spark/spark_venv/bin/activate

# Iniciar JupyterLab
jupyter lab --ip=0.0.0.0 --no-browser --allow-root &

# Mantener el entorno virtual activo (si es necesario)
# Puedes añadir otros procesos que necesites ejecutar aquí.

# El script seguirá corriendo en segundo plano
echo "JupyterLab y Spark están en ejecución"
