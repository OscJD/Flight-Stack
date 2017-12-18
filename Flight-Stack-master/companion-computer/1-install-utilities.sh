#!/bin/bash
""" Flight Stack """
""" instalacion.py -> Script que instala las herramientas necesarias para que el RPI comande al Pixhawk/APM. """

__author__ = "Aldo Vargas"
__copyright__ = "Copyright 2017 Altax.net"

__license__ = "GPL"
__version__ = "1.0"
__maintainer__ = "Aldo Vargas"
__email__ = "aldo@altax.net"
__status__ = "Desarrollo"

# Find out which OS is running:
askOS () {
	plataform="unknown"
	unamestr=`uname`
	case "$unamestr" in
		"Linux") plataform='installLinux'
		;;
		*)
		echo ""
		echo "Lo siento, plataforma no soportada... :("
		echo ""
		exit
		;;
	esac
}
askOS;

installLinux () {
	PACK[0]="python-dev"
	PACK[1]="screen"
	PACK[2]="python-matplotlib"
	PACK[3]="python-opencv"
	PACK[4]="python-pip"
	PACK[5]="python-numpy"
	PACK[6]="python-serial"
	PACK[7]="gstreamer1.0"
	echo ""
	echo "-> Empezando instalacion en Linux!"
	echo ""
	sleep 2
	echo "-> Actualizando sistema usando apt-get... (este script pedira contraseña de administrador)"
	echo ""
	sudo apt-get update
	sudo apt-get upgrade -y
	echo ""
	echo "-> Instalando paquetes necesarios..."
	echo ""
	sudo apt-get install ${PACK[*]} -y
	echo ""
	echo "-> Actualizando pip..."
	echo ""
	yes | pip install --upgrade pip
	echo ""
	echo "-> Quitando instalaciones previas..."
	echo ""
	sleep 2
	sudo pip uninstall dronekit -y
	sudo pip uninstall MAVProxy -y
	sudo pip uninstall pymavlink -y
	echo ""
	echo "-> Instalando nuevos paquetes!"
	echo ""
	yes | sudo pip install MAVProxy
	yes | sudo pip install dronekit
	yes | sudo pip install dronekit-sitl
	echo ""
	echo ""
	echo "Si encontraste errores, manda correos a: aldo@altax.net"
	echo ""
}

clear
echo ""
echo "------------ AlTaX Consulting ----------"
echo "----------- Script instalacion ---------"
echo ""
echo "Hola!"
echo ""
echo "Encontre $unamestr como sistema operativo..."
echo "Esta herramienta esta diseñada para trabajar con sistems MacOSX/Linux conectados a internet."
echo "(En caso de mac, necesito homebrew instalado)"
echo ""
echo "Tu computadora cumple con estos requerimientos?:"
select yn in "Si" "No"; do
    case $yn in
        Si ) $plataform; break;;
        No ) echo ""; echo "Bye!"; echo ""; exit;;
    esac
done
