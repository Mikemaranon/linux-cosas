#!/bin/bash

sudo systemctl enable ssh
sudo systemctl start ssh

sudo apt install python3-pip -y
pip3 install jupyter-core -y
sudo apt install openssh-server -y

