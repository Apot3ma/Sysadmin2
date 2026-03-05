#!/bin/bash

echo "Actualizando repositorios..."
sudo apt update

echo "Instalando OpenSSH Server..."
sudo apt install openssh-server -y

echo "Iniciando servicio SSH..."
sudo systemctl start ssh

echo "Habilitando inicio automatico..."
sudo systemctl enable ssh

echo "SSH instalado correctamente"