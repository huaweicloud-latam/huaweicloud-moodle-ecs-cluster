#!/bin/bash
### Version v1.01 ###
## 20221123: Fix the moodledata issue -Nestor ##

export OUTLOG="/var/log/auto-installation-log.log"
export DEBIAN_FRONTEND=noninteractive

##### START IF #############################################################################################################################################
if cat /etc/*release | grep ^PRETTY_NAME | grep "Debian GNU/Linux 10" > /dev/null ; then
######## IF THE OS VERSION IS DEBIAN 10, then execute the following commands. ##############################################################################
date > $OUTLOG 2>&1

echo "### Update & Upgrade Start ###" >>$OUTLOG
apt-get update >> $OUTLOG 2>&1
apt-get -y upgrade >> $OUTLOG 2>&1
echo "### Update & Upgrade End ###" >>$OUTLOG

echo "### Apache2 Start ###" >>$OUTLOG
apt-get -y install apache2 >>$OUTLOG 2>&1
echo "### Apache2 End ###" >>$OUTLOG

echo "### Update LSB-release Start ###" >>$OUTLOG
apt-get -y install lsb-release apt-transport-https ca-certificates  >>$OUTLOG 2>&1
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg   >>$OUTLOG 2>&1
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list >>$OUTLOG 2>&1
echo "### Update LSB-release End ###" >>$OUTLOG

echo "### PHP7.4 Start ###" >>$OUTLOG
apt-get -y update >>$OUTLOG 2>&1
apt-get -y install php7.4 php7.4-mysql php7.4-xml php7.4-mbstring php7.4-curl php7.4-zip php7.4-intl php7.4-xmlrpc php7.4-soap php7.4-gd php7.4-redis >>$OUTLOG 2>&1
echo "### PHP7.4 End ###" >>$OUTLOG

echo "### MySQL Client Start ###" >>$OUTLOG
apt-get -y install default-mysql-client >>$OUTLOG
echo "### MySQL Client End ###" >>$OUTLOG

echo "### NFS Client Start ###" >>$OUTLOG
apt-get -y install nfs-common >>$OUTLOG
echo "### NFS Client End ###" >>$OUTLOG




echo "### Mount NFS Network File System Start ###" >> $OUTLOG

mkdir /var/www/moodleapp >>$OUTLOG 2>&1

touch /etc/systemd/system/var-www-moodleapp.mount >>$OUTLOG 2>&1

cat << EOF-MOUNT > /etc/systemd/system/var-www-moodleapp.mount

[Unit]
Description=NFS Share from NFS File System
DefaultDependencies=no
Conflicts=umount.target
After=network-online.target remote-fs.target
Before=umount.target

[Mount]
What=SFS_EXPORT_LOCATION
Where=/var/www/moodleapp
Type=nfs
Options=defaults

[Install]
WantedBy=multi-user.target

EOF-MOUNT

systemctl daemon-reload >>$OUTLOG 2>&1
systemctl enable var-www-moodleapp.mount >>$OUTLOG 2>&1
systemctl start var-www-moodleapp.mount >>$OUTLOG 2>&1
systemctl status var-www-moodleapp.mount >>$OUTLOG 2>&1

echo "### Mount NFS Network File System End ###" >> $OUTLOG


echo "### Moodle 3.11 Start ###" >>$OUTLOG
cd /var/www/moodleapp >>$OUTLOG 2>&1
wget -q https://download.moodle.org/download.php/direct/stable311/moodle-latest-311.tgz 1> /dev/null 2>>$OUTLOG
tar zxvf /var/www/moodleapp/moodle-latest-311.tgz -C /var/www/moodleapp 1> /dev/null 2>>$OUTLOG
mkdir /var/www/moodleapp/moodledata >>$OUTLOG 2>&1
chown -R www-data:www-data moodle >>$OUTLOG 2>&1
chown -R www-data:www-data moodledata >>$OUTLOG 2>&1
chmod -R 755 /var/www/moodleapp/moodle >>$OUTLOG 2>&1
chmod -R 755 /var/www/moodleapp/moodledata >>$OUTLOG 2>&1
sed -i "s/\/var\/www\/html/\/var\/www\/moodleapp\/moodle/g" /etc/apache2/sites-available/000-default.conf >>$OUTLOG 2>&1
/etc/init.d/apache2 restart >>$OUTLOG 2>&1
echo "### Moodle 3.11 End ###" >>$OUTLOG


echo "### SHUTDOWN START###" >>$OUTLOG
shutdown -h now >>$OUTLOG 2>&1

##### Otherwise, exit! ###############################################################################################################################
else
    echo "Please use Debian GNU/Linux 10 to create ECS."
        exit 1;
fi
##### END IF #########################################################################################################################################

