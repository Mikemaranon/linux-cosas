#!/bin/bash

# Activar el entorno virtual de Spark
source /opt/spark/spark_venv/bin/activate

# Iniciar JupyterLab y redirigir los logs a un archivo temporal
jupyter lab --ip=0.0.0.0 --no-browser --allow-root > /tmp/jupyter_logs.txt 2>&1 &

# Esperar a que JupyterLab inicie
sleep 5

# Leer el token desde los logs generados por JupyterLab
TOKEN=$(grep -o 'token=[^ ]*' /tmp/jupyter_logs.txt | head -n 1 | cut -d'=' -f2)

# Mostrar el mensaje con el token de autenticación
echo "JupyterLab y Spark están en ejecución"
echo "Accede a JupyterLab usando el siguiente token de autenticación:"
echo $TOKEN
