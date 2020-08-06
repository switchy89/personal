#!/bin/bash
clear
tput bold ; printf '%35s%s%-20s\n' "Eliminare un Utente!" ; tput sgr0
echo ""
tput bold ; echo "Lista degli utenti:" ; tput sgr0 ; echo "" ;
awk -F : '$3 >= 500 { print $1 }' /etc/passwd | grep -v '^nobody'
echo ""
tput bold ; read -p "Nome utente da rimuovere: " user ; tput sgr0
if [[ -z $user ]]
then
	tput bold ; echo "" ; echo "hai inserito un utente non valido" ; tput sgr0 ; echo "" ;
	exit 1
else
	if [[ `grep -c /$user: /etc/passwd` -ne 0 ]]
	then
		ps x | grep $user | grep -v grep | grep -v pt > /tmp/rem
		if [[ `grep -c $user /tmp/rem` -eq 0 ]]
		then
			deluser $user > /dev/null
			tput bold ; echo "" ; echo "L'utente $user è stato rimosso!" ; tput sgr0 ; echo "" ;
			grep -v ^$user[[:space:]] /root/utenti.db > /tmp/ph ; cat /tmp/ph > /root/utenti.db
			exit 1
		else
			echo "" ; echo "Utente connesso. Disconnessione ..." ;
			pkill -f "$user"
			deluser $user > /dev/null
			tput bold ; echo "" ; echo "L'utente $user è stato rimosso con successo!" ; tput sgr0 ; echo "" ;
			grep -v ^$user[[:space:]] /root/utenti.db > /tmp/ph ; cat /tmp/ph > /root/utenti.db
			exit 1
		fi
	else
		tput bold ; echo "" ; echo "L'utente $user non esiste!" ; tput sgr0 ; echo "" ;
	fi
fi
