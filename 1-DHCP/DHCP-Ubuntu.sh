#!/bin/bash


echo "==== CONFIGURACION SERVIDOR DHCP ===="

# ---------- VERIFICAR INSTALACION ----------

if ! dpkg -l | grep -q isc-dhcp-server; then
    echo "Instalando isc-dhcp-server..."
    sudo apt update
    sudo apt install -y isc-dhcp-server
else
    echo "DHCP ya instalado"
fi



# ---------- PARAMETROS DINAMICOS ----------

read -p "Nombre del scope: " SCOPE
read -p "IP inicial del rango: " IP_START
read -p "IP final del rango: " IP_END
read -p "Tiempo de concesion (segundos): " LEASE
read -p "Gateway: " ROUTER
read -p "DNS: " DNS



# ---------- CONFIGURAR INTERFAZ ----------

cat <<EOF | sudo tee /etc/default/isc-dhcp-server
INTERFACESv4="ens37"
INTERFACESv6=""
EOF



# ---------- CONFIGURAR DHCP ----------

cat <<EOF | sudo tee /etc/dhcp/dhcpd.conf
default-lease-time $LEASE;
max-lease-time $LEASE;



subnet 77.77.77.0 netmask 255.255.255.0 {
    range $IP_START $IP_END;
    option routers $ROUTER;
    option domain-name-servers $DNS;
}
EOF



# ---------- VALIDAR CONFIG ----------

echo "Validando configuracion..."
sudo dhcpd -t



if [ $? -ne 0 ]; then
    echo "ERROR en configuracion DHCP"
    exit 1
fi



# ---------- REINICIAR SERVICIO ----------

sudo systemctl restart isc-dhcp-server



# ---------- ESTADO ----------

echo "Estado del servicio:"
sudo systemctl status isc-dhcp-server --no-pager


# ---------- MONITOREO ----------

echo "Concesiones activas:"
cat /var/lib/dhcp/dhcpd.leases


echo "Configuracion completada"
