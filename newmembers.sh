#!/bin/bash
#Script auto create user SSH

read -p "Username : " Login
read -p "Password : " Pass
read -p "Expired (hari): " Expired

IP=`dig +short myip.opendns.com @resolver1.opendns.com`
useradd -e `date -d "$Expired days" +"%Y-%m-%d"` -s /bin/false -M $Login
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
echo -e ""
echo -e "====Information SSH account===="
echo -e "Host: $IP" 
echo -e "Port OpenSSH: 22,110,143"
echo -e "Port Dropbear: 80,443"
echo -e "Port Squid: 8080,3128"
echo -e "Config OpenVPN (TCP 1194): http://$IP:81/client.ovpn"
echo -e "Username: $Login "
echo -e "Password: $Pass"
echo -e "-----------------------------"
echo -e "Expired Date: $exp"
echo -e "============================="
echo -e "./Bryan"
echo -e ""
