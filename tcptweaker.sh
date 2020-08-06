#!/bin/bash
clear
tput bold ; printf '%35s%s%-20s\n' "TCP Tweaker 1.0" ; tput sgr0
if [[ `grep -c "^#L1nux" /etc/sysctl.conf` -eq 1 ]]
then
	echo ""
	echo "Le impostazioni di rete di TCP Tweaker sono già state aggiunte al sistema!"
	echo ""
	read -p "Vuoi rimuovere le impostazioni di TCP Tweaker? [s/n]: " -e -i n risposta0
	if [[ "$risposta0" = 's' ]]; then
		grep -v "^#L1nux
net.ipv4.tcp_window_scaling = 1
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 16384 16777216
net.ipv4.tcp_low_latency = 1
net.ipv4.tcp_slow_start_after_idle = 0" /etc/sysctl.conf > /tmp/syscl && mv /tmp/syscl /etc/sysctl.conf
sysctl -p /etc/sysctl.conf > /dev/null
		echo ""
		echo "Le impostazioni di rete di TCP Tweaker sono state rimosse correttamente."
		echo ""
	exit
	else 
		echo ""
		exit
	fi
else
	echo ""
	echo "Questo è uno script sperimentale. Utilizzare a proprio rischio!"
	echo "Questo script modificherà alcune impostazioni di rete"
	echo "del sistema per ridurre la latenza e migliorare la velocità."
	echo ""
	read -p "Continuare con l'installazione? [s/n]: " -e -i s risposta
	if [[ "$risposta" = 's' ]]; then
	echo ""
	tput bold ; echo "Modifica delle seguenti impostazioni:" ; tput sgr0
	echo " " >> /etc/sysctl.conf
	echo "#L1nux" >> /etc/sysctl.conf
echo "net.ipv4.tcp_window_scaling = 1
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 16384 16777216
net.ipv4.tcp_low_latency = 1
net.ipv4.tcp_slow_start_after_idle = 0" >> /etc/sysctl.conf
echo ""
sysctl -p /etc/sysctl.conf
		echo ""
		tput bold ; echo "Le impostazioni di rete di TCP Tweaker sono state aggiunte correttamente." ; tput sgr0
		echo ""
	else
		echo ""
		tput bold ; echo "L'installazione è stata annullata dall'utente!" ; tput sgr0
		echo ""
	fi
fi
exit
