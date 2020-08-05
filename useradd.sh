#!/bin/bash
echo "Creiamo un nuovo Utente!"
echo ""
read -p "nome: " username
awk -F : ' { print $1 }' /etc/passwd > /tmp/users 
if grep -Fxq "$username" /tmp/users
then
	echo "Questo utente già esiste. Crea un utente con un nome diverso."
	exit 1	
else
	if (echo $username | egrep [^a-zA-Z0-9.-_] &> /dev/null)
	then
		echo "" ; echo "Hai inserito un nome utente valido!" ; echo "utilizza solo lettere, numeri, punti e trattini." ; echo "Non utilizzare spazi, accenti o caratteri speciali!" ; echo ""	;	exit 1
	else
		sizemin=$(echo ${#username})
		if [[ $sizemin -lt 2 ]]
		then
			echo "" ; echo "Hai inserito un nome utente troppo breve," ; echo "utilizzare almeno due caratteri!" ; echo "" ;
			exit 1
		else
			sizemax=$(echo ${#username})
			if [[ $sizemax -gt 32 ]]
			then
				echo "" ; echo "Hai inserito un nome utente troppo lungo," ; echo "utilizza al massimo 32 caratteri!" ; echo "" ;
				exit 1
			else
				if [[ -z $username ]]
				then
					echo "" ; echo "Hai inserito un nome utente vuoto!" ; echo "" ;
					exit 1
				else	
					read -p "password: " password
					if [[ -z $password ]]
					then
						echo "" ; echo "Hai inserito una password vuota!" ; echo "" ;
						exit 1
					else
						sizepass=$(echo ${#password})
						if [[ $sizepass -lt 6 ]]
						then
							echo "" ; echo "Hai inserito una password troppo breve!" ; echo "Per mantenere l'utente al sicuro inserisci almeno 6 caratteri" ; echo "utilizza combinazioni di lettere e numeri diversi!" ; echo "" ;
							exit 1
						else	
							read -p "Nr. Giorni alla scadenza: " giorni
							if (echo $giorni | egrep '[^0-9]' &> /dev/null)
							then
								echo "" ; echo "Hai inserito un numero di giorni non valido!" ; echo "" ;
								exit 1
							else
								if [[ -z $giorni ]]
								then
									echo "" ; echo "Hai lasciato vuoto il numero di giorni per la scadenza dell'account!" ; echo "" ;
									exit 1
								else	
									if [[ $giorni -lt 1 ]]
									then
										echo "" ; echo "devi inserire un numero di giorni maggiore di zero!" ; echo "" ;
										exit 1
									else
										final=$(date "+%Y-%m-%d" -d "+$giorni days")
										gui=$(date "+%d/%m/%Y" -d "+$giorni days")
										pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
										useradd -e $final -M -s /bin/false -p $pass $username
										[ $? -eq 0 ] && echo ""; echo "Utente $username creato" ; echo "Data di scadenza: $gui" ; echo "" || echo "Non è possibile creare l'utente!" ;
										echo "$username" >> /root/utenti.db
									fi
								fi
							fi
						fi
					fi
				fi
			fi
		fi
	fi	
fi
