#!/bin/bash
echo "Eliminare Utente"
echo ""
echo "Lista degli utenti:" ; echo "" ;
awk -F : '$3 >= 500 { print $1 }' /etc/passwd | grep -v '^nobody'
echo ""
read -p "Nome utente da rimuovere: " user
if [[ -z $user ]]
then
	echo "" ; echo "hai inserito un utente non valido" ; echo "" ;
	exit 1
else
	if [[ `grep -c /$user: /etc/passwd` -ne 0 ]]
	then
		ps x | grep $user | grep -v grep | grep -v pt > /tmp/rem
		if [[ `grep -c $user /tmp/rem` -eq 0 ]]
		then
			deluser $user > /dev/null
			echo "" ; echo "L'utente $user è stato rimosso!" ; echo "" ;
			grep -v ^$user[[:space:]] /root/utenti.db > /tmp/ph ; cat /tmp/ph > /root/utenti.db
			exit 1
		else
			echo "" ; echo "Utente connesso. Disconnessione ..." ;
			pkill -f "$user"
			deluser $user > /dev/null
			echo "" ; echo "L'utente $user è stato rimosso con successo!" ; echo "" ;
			grep -v ^$user[[:space:]] /root/utenti.db > /tmp/ph ; cat /tmp/ph > /root/utenti.db
			exit 1
		fi
	else
		echo "" ; echo "L'utente $user non esiste!" ; echo "" ;
	fi
fi
