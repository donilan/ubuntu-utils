#!/bin/bash
# /etc/dhcp3/dhclient-exit-hooks.d/wireless-gw
# /etc/network/if-up.d/wireless-gw

WIRELESS=`iwconfig 2>/dev/null| awk 'NR==1 {print $1}'`
[ -z "$WIRELESS" ] && exit 0

gw=`ip addr show dev $WIRELESS | grep "inet " | awk 'NR==1 {print $2}'`
[ `echo $gw | awk -F. '{print NF}'` -ne 4 ] && exit 0

gw=`echo $gw | awk -F. '{printf("%s.%s.%s.1",$1,$2,$3)}'`

while [ `ip route | grep ^default | wc -l` -gt 0 ]
do
sudo ip route delete default
done
sudo ip route add default via $gw

#echo nameserver $gw > /etc/resolv.conf
echo nameserver 8.8.8.8 > /etc/resolv.conf
echo nameserver 8.8.4.4 >> /etc/resolv.conf