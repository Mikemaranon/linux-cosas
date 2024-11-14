#!/bin/bash

sudo systemctl enable ssh
sudo systemctl start ssh

sudo apt install python3-pip -y
pip3 install jupyter-core 
sudo apt install openssh-server -y
pip3 install jupyterlab
pip3 install notebook
