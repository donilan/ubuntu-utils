#!/bin/sh

(
echo \
"en_HK.UTF-8 UTF-8
en_DK.UTF-8 UTF-8
en_IN UTF-8
en_ZM UTF-8
en_ZW.UTF-8 UTF-8
en_NZ.UTF-8 UTF-8
en_PH.UTF-8 UTF-8
en_NG UTF-8
en_US.UTF-8 UTF-8
en_GB.UTF-8 UTF-8
en_AU.UTF-8 UTF-8
en_SG.UTF-8 UTF-8
en_BW.UTF-8 UTF-8
en_AG UTF-8
en_ZA.UTF-8 UTF-8
en_CA.UTF-8 UTF-8
en_IE.UTF-8 UTF-8"
) > /var/lib/locales/supported.d/en
locale-gen --purge

cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo "export TZ='Asia/Shanghai'" >> ~/.profile
export TZ='Asia/Shanghai'



##soft
/etc/init.d/apache2 stop
apt-get remove apache2 -y
apt-get update
apt-get upgrade -y
apt-get install aptitude -y

#editor
apt-get install emacs -y
export EDITOR='emacs'
echo "export EDITOR='emacs'" >> ~/.profile

#chkconfig
apt-get install chkconfig -y

#mail forward
echo 'donilan.qq@gmail.com' >> ~/.forward

##java memory
export _JAVA_OPTIONS="-Xms20m -Xmx64m -XX:MinHeapFreeRatio=20 -XX:MaxHeapFreeRatio=40 -XX:NewSize=10m -XX:MaxNewSize=10m -XX:SurvivorRatio=6 -XX:TargetSurvivorRatio=80 -XX:+CMSClassUnloadingEnabled -XX:+CMSPermGenSweepingEnabled"

echo "export _JAVA_OPTIONS='-Xms20m -Xmx64m -XX:MinHeapFreeRatio=20 -XX:MaxHeapFreeRatio=40 -XX:NewSize=10m -XX:MaxNewSize=10m -XX:SurvivorRatio=6 -XX:TargetSurvivorRatio=80 -XX:+CMSClassUnloadingEnabled -XX:+CMSPermGenSweepingEnabled'" >> ~/.profile