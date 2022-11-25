#!/bin/bash

#Colores
greenColour="\e[0;32m\033[1m"
redColour="\e[0;31m\033[1m"
endColour="\033[0m\e[0m"

function ctrl_c(){
    echo -e "\n ${redColour}[*] Saliendo del programa${endColour}"
    exit 1
}

# Control+C
trap ctrl_c INT

# Comprobación de argumentos
    if [ $# -eq 1 ]; then
        if [[ "$1" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
            echo -e "\n ${greenColour}[*] Reconocimiento inicial de puertos${endColour}\n"
            ip=$1
            nmap -p- --open -T5 -v -n $ip -oG ports.tmp
        else
            echo -e "\n ${redColour}[*] Introduce una IPv4 correcta${endColour}\n" 
            exit 1
        fi
    else
        echo -e "\n ${redColour}[*] Introduce solamente la IP a escanear${endColour}\n"
        exit 1
    fi

# Escaneo de puertos
    ports="$(cat ports.tmp | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"
    echo -e "\t[*] Dirección IP: $ip" > ListaPuertos
    echo -e "\t[*] Puertos abiertos: $ports\n" >> ListaPuertos
    echo -e "\n ${greenColour}[*] Escaneo avanzado de servicios\n${endColour}" 
    nmap -sCV -p$ports $ip -oN InfoPuertos
    rm ports.tmp
    echo -e "\n ${greenColour}[*] Escaneo completado, se han generado los ficheros ListaPuertos e InfoPuertos\n${endColour}" 