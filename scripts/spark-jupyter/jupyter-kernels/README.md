# Java, C/C++ & JS en Jupyter Lab

Esta extensión del tutorial de la instalación de Jupyter lab incluye la instalación de kernels adicionales para poder ejecutar otros lenguajes en jupyter-lab, pudiendo usarlo como un IDE más allá de ejecutar Notebooks y codigos en python

## Preparación: Instalación de Conda

>**Info**
>`Conda` es un gestor de paquetes y de entornos que puede manejar dependencias e instalaciones de paquetes para `varios lenguajes de programación`, no solo Python. A diferencia de `pip`, que se limita a gestionar unicamente paquetes de `Python`. `Conda` permite crear entornos aislados que incluyen paquetes de diferentes lenguajes (como Python, R, Julia, entre otros). En el contexto de `Jupyter Lab`, Conda puede ser utilizado para gestionar las dependencias necesarias y crear entornos de trabajo, lo cual facilita la instalación de bibliotecas y herramientas de manera controlada. Aunque no es estrictamente necesario para usar Jupyter Lab, usar Conda es útil para gestionar entornos y dependencias de forma más eficiente, especialmente en proyectos que requieren varios paquetes o lenguajes.

primero de todo vamos a descargar el script desde este url:
```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
```
luego tenemos que darle permisos de ejecución
```bash
sudo chmod +x Miniconda3-latest-Linux-x86_64.sh
```
Ahora lo ejecutamos
```bash
bash Miniconda3-latest-Linux-x86_64.sh
```
Una vez tengamos estos pasos, aztualizamos terminal y verificamos la versión de conda
```bash
source ~/.bashrc
conda --version
```

## Instalación de kernels

Para este script he contemplado los kernels de Java y C/C++.
primero de todo vamos a darle permisos de ejecución al script.
```bash
sudo chmod +x install-kernels.sh
```
luego ya lo ejecutamos
```bash
sudo ./install-kernels.sh
```

## Troubleshooting: Reparación de Jupyter
Si tenemos problemas detectando algunos comandos con jupyter, podemos ejecutar los siguientes comandos:
```bash
pip install --upgrade --force-reinstall jupyter
pip install ipykernel
```
Ahora vamos a instalar el paquete que hace que jupyter reconozca los kernels
```bash
conda install ipykernel
```
comprobamos los kernels instalados:
```bash
jupyter kernelspec list
```

## Integración de kernels restantes

Habremos instalado los kernels en `conda` y `pip` pero no necesariamente son reconocidos por Jupyter Lab (en mi caso el de java no se habia integrado). Vamos a integrarlos
```bash
# Kernel de java
python -m ipykernel install --user --name java --display-name "Java Kernel"

# Kernel de C++17
python -m jupyter kernelspec install ~/miniconda3/share/jupyter/kernels/xcpp17 --user
```

finalmente, si queremos simular servidores web en nuestros proyectos sin usar `flask` ni `django` u otros frameworks, podemos usar el siguiente script y ejecutarlo desde jupyter

```python
import http.server
import socketserver

PORT = 8000

Handler = http.server.SimpleHTTPRequestHandler

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"Serving at port {PORT}")
    httpd.serve_forever()
```
para ponerlo en funcionamiento ejecutamos una celda en jupyter:
```bash
!python3 server.py
```