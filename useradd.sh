#!/bin/bash
clear
tput bold ; printf '%35s%s%-20s\n' "Creiamo un nuovo Utente!" ; tput sgr0
echo ""
tput bold ; read -p "nome: " username ; tput sgr0
awk -F : ' { print $1 }' /etc/passwd > /tmp/users 
if grep -Fxq "$username" /tmp/users
then
	tput bold ; echo "Questo utente già esiste. Crea un utente con un nome diverso." ; tput sgr0
	exit 1	
else
	if (echo $username | egrep [^a-zA-Z0-9.-_] &> /dev/null)
	then
		tput bold ; echo "" ; echo "Hai inserito un nome utente invalido!" ; echo "utilizza solo lettere, numeri, punti e trattini." ; echo "Non utilizzare spazi, accenti o caratteri speciali!" ; echo ""	; tput sgr0
		exit 1
	else
		sizemin=$(echo ${#username})
		if [[ $sizemin -lt 2 ]]
		then
			tput bold ; echo "" ; echo "Hai inserito un nome utente troppo breve," ; echo "utilizzare almeno due caratteri!" ; ; tput sgr0 ; echo "" ;
			exit 1
		else
			sizemax=$(echo ${#username})
			if [[ $sizemax -gt 32 ]]
			then
				tput bold ; echo "" ; echo "Hai inserito un nome utente troppo lungo," ; echo "utilizza al massimo 32 caratteri!" ; tput sgr0 ; echo "" ;
				exit 1
			else
				if [[ -z $username ]]
				then
					tput bold ; echo "" ; echo "Hai inserito un nome utente vuoto!" ; tput sgr0 ; echo "" ;
					exit 1
				else	
					tput bold ; read -p "password: " password ; tput sgr0
					if [[ -z $password ]]
					then
						tput bold ; echo "" ; echo "Hai inserito una password vuota!" ; tput sgr0 ; echo "" ;
						exit 1
					else
						sizepass=$(echo ${#password})
						if [[ $sizepass -lt 6 ]]
						then
							tput bold ; echo "" ; echo "Hai inserito una password troppo breve!" ; echo "Per mantenere l'utente al sicuro inserisci almeno 6 caratteri" ; echo "utilizza combinazioni di lettere e numeri diversi!" ; tput sgr0 ; echo "" ;
							exit 1
						else	
							tput bold ; read -p "Nr. Giorni alla scadenza: " giorni ; tput sgr0
							if (echo $giorni | egrep '[^0-9]' &> /dev/null)
							then
								tput bold ; echo "" ; echo "Hai inserito un numero di giorni non valido!" ; tput sgr0 ; echo "" ;
								exit 1
							else
								if [[ -z $giorni ]]
								then
									tput bold ; echo "" ; echo "Hai lasciato vuoto il numero di giorni per la scadenza dell'account!" ; tput sgr0 ; echo "" ;
									exit 1
								else	
									if [[ $giorni -lt 1 ]]
									then
										tput bold ; echo "" ; echo "devi inserire un numero di giorni maggiore di zero!" ; tput sgr0 ; echo "" ;
										exit 1
									else
										final=$(date "+%Y-%m-%d" -d "+$giorni days")
										gui=$(date "+%d/%m/%Y" -d "+$giorni days")
										pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
										useradd -e $final -M -s /bin/false -p $pass $username
										[ $? -eq 0 ] && echo ""; tput bold ; echo "Utente $username creato" ; echo "Data di scadenza: $gui" ; echo "" || echo "Non è possibile creare l'utente!" ; tput sgr0
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
