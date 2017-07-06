#!/bin/bash
#############################################
#         Author BY :                       #
#                     Nugroho a.k.a ./Bryan # 
#############################################

# initialisasi Certificate
apt-get install ca-certificates

# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";

# go to root
cd

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# install wget and curl
apt-get update;apt-get -y install wget curl;

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart

# set repo
wget -O /etc/apt/sources.list "https://raw.githubusercontent.com/ForNesiaFreak/FNS_Debian7/fornesia.com/null/sources.list.debian7"
wget "http://www.dotdeb.org/dotdeb.gpg"
wget "http://www.webmin.com/jcameron-key.asc"
cat dotdeb.gpg | apt-key add -;rm dotdeb.gpg
cat jcameron-key.asc | apt-key add -;rm jcameron-key.asc

# update
apt-get update

# install webserver
apt-get -y install nginx

# install essential package
apt-get -y install bmon iftop htop nmap axel nano iptables traceroute sysv-rc-conf dnsutils bc nethogs openvpn vnstat less screen psmisc apt-file whois ptunnel ngrep mtr git zsh mrtg snmp snmpd snmp-mibs-downloader unzip unrar rsyslog debsums rkhunter
apt-get -y install build-essential

# disable exim
service exim4 stop
sysv-rc-conf exim4 off

# update apt-file
apt-file update

# install figlet
apt-get install figlet
echo "clear" >> .bashrc
echo 'figlet -k "$HOSTNAME"' >> .bashrc
echo 'echo -e "Welcome To My Server $HOSTNAME"' >> .bashrc
echo 'echo -e "Script Create By ./Bryan"' >> .bashrc
echo 'echo -e "Please Type Menu To View Command List Available"' >> .bashrc
echo 'echo -e "Thankyou"' >> .bashrc

# install webserver
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/NugrohoSu/BryanRepo/master/nginx.conf"
mkdir -p /home/vps/public_html
echo "<pre>Setup by Rizal Hidayat | 081515292117</pre>" > /home/vps/public_html/index.html
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/NugrohoSu/BryanRepo/master/vps.conf"
service nginx restart

# install openvpn
wget -O /etc/openvpn/openvpn.tar "https://raw.githubusercontent.com/NugrohoSu/BryanRepo/master/openvpn-debian.tar"
cd /etc/openvpn/
tar xf openvpn.tar
wget -O /etc/openvpn/1194.conf "https://raw.githubusercontent.com/NugrohoSu/BryanRepo/master/1194.conf"
service openvpn restart
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
iptables -t nat -I POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE
iptables-save > /etc/iptables_yg_baru_dibikin.conf
wget -O /etc/network/if-up.d/iptables "https://raw.githubusercontent.com/NugrohoSu/BryanRepo/master/iptables"
chmod +x /etc/network/if-up.d/iptables
service openvpn restart

#konfigurasi openvpn
cd /etc/openvpn/
wget -O /etc/openvpn/client.ovpn "https://raw.githubusercontent.com/NugrohoSu/BryanRepo/master/client-1194.conf"
sed -i $MYIP2 /etc/openvpn/client.ovpn;
cp client.ovpn /home/vps/public_html/

cd
# install badvpn
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/NugrohoSu/BryanRepo/master/badvpn-udpgw"
if [ "$OS" == "x86_64" ]; then
  wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/NugrohoSu/BryanRepo/master/badvpn-udpgw64"
fi
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300

cd
# setting port ssh
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 110' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
service ssh restart

# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=443/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 443 -p 80"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
service ssh restart
service dropbear restart

cd

# install squid3
apt-get -y install squid3
wget -O /etc/squid3/squid.conf "https://raw.githubusercontent.com/NugrohoSu/BryanRepo/master/squid3.conf"
sed -i $MYIP2 /etc/squid3/squid.conf;
service squid3 restart

# install webmin
cd
wget -O webmin-current.deb "http://www.webmin.com/download/deb/webmin-current.deb"
dpkg -i --force-all webmin-current.deb;
apt-get -y -f install;
rm /root/webmin-current.deb
service webmin restart

# download script
cd /usr/bin
wget -O /List "https://raw.githubusercontent.com/NugrohoSu/BryanRepo/master/List.sh"
wget -O /Newmembers "https://raw.githubusercontent.com/NugrohoSu/BryanRepo/master/newmembers.sh"
wget -O /Trial "https://raw.githubusercontent.com/NugrohoSu/BryanRepo/master/Trial.sh"
wget -O /Remove "https://raw.githubusercontent.com/NugrohoSu/BryanRepo/master/Remove.sh"
wget -O /Check "https://raw.githubusercontent.com/NugrohoSu/BryanRepo/master/Check.sh"
wget -O /Members "https://raw.githubusercontent.com/NugrohoSu/BryanRepo/master/Members.sh"
wget -O /Maintance "https://raw.githubusercontent.com/NugrohoSu/BryanRepo/master/Maintance.sh"
wget -O /Speedtest "https://raw.githubusercontent.com/NugrohoSu/BryanRepo/master/Speedtest.py"
wget -O /About "https://raw.githubusercontent.com/NugrohoSu/BryanRepo/master/About.sh"
echo "0 0 * * * root /usr/bin/reboot" > /etc/cron.d/reboot
echo "* * * * * service dropbear restart" > /etc/cron.d/dropbear
chmod +x /List
chmod +x /Newmembers
chmod +x /Trial
chmod +x /Remove
chmod +x /Check
chmod +x /Members
chmod +x /Maintance
chmod +x /Speedtest
chmod +x /About

# finishing
cd
chown -R www-data:www-data /home/vps/public_html
service nginx start
service openvpn restart
service cron restart
service ssh restart
service dropbear restart
service squid3 restart
service webmin restart
rm -rf ~/.bash_history && history -c
echo "unset HISTFILE" >> /etc/profile

# information
clear
echo "Autoscript Include:" | tee log-install.txt
echo "#############################################"
echo "#         Author BY :                       #"
echo "#                     Nugroho a.k.a ./Bryan #" 
echo "#############################################"
echo "===========================================" | tee -a log-install.txt
echo " Silahkan Ketik /List Untuk Menampilkan Semua Informasi Bash Yang Bisa Di Gunakan"
echo " Terimakasih, Jangan Lupa Kunjungi www.solocyberarmy.net"
echo " ./Bryan"
echo "==========================================="  | tee -a log-install.txt
cd
rm -f /root/bryanserver7.sh
