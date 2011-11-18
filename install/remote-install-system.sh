#!/bin/sh

apt-get install isc-dhcp-server tftpd-hpa
#sed -i 's/=\"no\"/=\"yes\"/' /etc/default/udhcpd 
rmdir /var/lib/tftpboot
ln -s /usr/lib/syslinux /var/lib/tftpboot
/etc/init.d/tftpd-hpa restart

mkdir /var/lib/tftphoot/syslinux.cfg