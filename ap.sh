#!/bin/sh

sudo iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -o ppp0 -j MASQUERADE
sudo iptables -A FORWARD -s 192.168.1.0/24 -o ppp0 -j ACCEPT
sudo iptables -A FORWARD -d 192.168.1.0/24 -m conntrack --ctstate ESTABLISHED,RELATED -i eth0 -j ACCEPT
sudo iptables -A INPUT -m conntrack --ctstate NEW -p tcp --dport 80 -j LOG --log-prefix "NEW_HTTP_CONN: "

sudo killall named
sudo killall hostapd
sudo ifconfig wlan1 192.168.1.1
sudo hostapd -B /etc/hostapd.conf
sudo /etc/init.d/dnsmasq restart