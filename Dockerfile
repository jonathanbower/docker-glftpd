FROM phusion/baseimage:0.11
CMD ["/sbin/my_init"]
COPY root/ /
RUN /root/glinstall.sh
RUN /root/pznginstall.sh
VOLUME /glftpd/site /glftpd/ftp-data
RUN apt-get remove -y wget unzip zip
RUN apt-get clean -y
RUN rm -rf /var/lib/apt/lists/* /var/cache/* /var/tmp/*
RUN cp -arp /glftpd/ftp-data /glftpd/ftp-data-dist
RUN rm -rf /glftpd/ftp-data/*
