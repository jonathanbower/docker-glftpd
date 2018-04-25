#!/bin/bash
cd /root
wget https://github.com/pzs-ng/pzs-ng/archive/master.zip
unzip master.zip -d /glftpd/ftp-data/
rm master.zip
cd /glftpd/ftp-data/pzs-ng-master
apt-get update
apt-get install -y gcc file make libssl-dev
./configure
sed -i 's/#define sfv_dirs.*/#define sfv_dirs                     "\/site\/x264\/ \/site\/tv\/ \/site\/dvdr\/ \/site\/games\ \/site\/requests\/ \/site\/x265\/ \/site\/xvid\/\"/' zipscript/conf/zsconfig.h
make
make install
echo "
calc_crc        *
post_check      /bin/zipscript-c *
cscript         DELE                    post    /bin/postdel
cscript         RMD                     post    /bin/datacleaner
cscript         SITE[:space:]NUKE       post    /bin/cleanup
cscript         SITE[:space:]UNNUKE     post    /bin/postunnuke
cscript         SITE[:space:]WIPE       post    /bin/cleanup
site_cmd        RESCAN                  EXEC    /bin/rescan
custom-rescan   !8      *
cscript         RETR                    post    /bin/dl_speedtest
site_cmd request       EXEC    /bin/tur-request.sh request
site_cmd reqfilled     EXEC    /bin/tur-request.sh reqfilled
site_cmd requests      EXEC    /bin/tur-request.sh status
site_cmd reqdel        EXEC    /bin/tur-request.sh reqdel
site_cmd reqwipe       EXEC    /bin/tur-request.sh reqwipe
custom-request         *
custom-reqfilled       *
custom-requests        *
custom-reqdel          *
custom-reqwipe         *" >> /glftpd/ftp-data/glftpd.conf
