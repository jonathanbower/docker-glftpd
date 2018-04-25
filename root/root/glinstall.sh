#!/bin/bash
# To install tzdata noninteractive
export DEBIAN_FRONTEND=noninteractive

# Install necessary packages
apt-get update
apt-get install -y wget ftp unzip zip xinetd tzdata

# Start xinetd so installer will go through without complaining
service xinetd start

# Download and install glftpd
cd /root
wget https://glftpd.eu/files/glftpd-LNX-2.08_1.1.0g_x64.tgz
tar xzvf glftpd-LNX-2.08_1.1.0g_x64.tgz
rm glftpd-LNX-2.08_1.1.0g_x64.tgz
cd glftpd-LNX-2.08_1.1.0g_x64
{ echo; echo n; echo n; echo; echo; echo; echo x; echo n; echo /ftp-data; echo; echo; echo; } | ./installgl.sh
# ^ bug on line 1251, //ftp-data

# move glftpd.conf so it can easily be mounted on host
mv /etc/glftpd.conf /glftpd/ftp-data/
sed -i '/server_args/s/$/-r \/glftpd\/ftp-data\/glftpd.conf/' /etc/xinetd.d/glftpd
echo "0  0 * * *      /glftpd/bin/reset -r /glftpd/ftp-data/glftpd.conf" | crontab -

# change location of passwd and group so it can easily be mounted on host
mv /glftpd/etc/passwd /glftpd/ftp-data/
mv /glftpd/etc/group /glftpd/ftp-data/
sed -i '/^datapath/a pwd_path        /ftp-data/passwd' /glftpd/ftp-data/glftpd.conf
sed -i '/^pwd_path/a grp_path        /ftp-data/group' /glftpd/ftp-data/glftpd.conf

# disable IPV6
sed -i 's/IPv6$//' /etc/xinetd.d/glftpd
