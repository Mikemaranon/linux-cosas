#!/bin/bash

# Definir el archivo de servicio
SERVICE_FILE="/etc/systemd/system/spark-jupyter.service"

# Crear el archivo de servicio Systemd
echo "[Unit]
Description=Start Spark and JupyterLab
After=network.target

[Service]
Type=simple
User=mike
ExecStart=/bin/bash /opt/spark/start_spark.sh
WorkingDirectory=/opt/spark
Restart=always
Environment=VIRTUAL_ENV=/opt/spark/spark_venv
Environment=PATH=\$VIRTUAL_ENV/bin:\$PATH

[Install]
WantedBy=multi-user.target" | sudo tee $SERVICE_FILE > /dev/null

# Recargar systemd para que reconozca el nuevo servicio
sudo systemctl daemon-reload

# Habilitar el servicio para que se ejecute al inicio
sudo systemctl enable spark-jupyter.service

# Iniciar el servicio de inmediato
sudo systemctl start spark-jupyter.service

# Verificar que el servicio se esté ejecutando
sudo systemctl status spark-jupyter.service
