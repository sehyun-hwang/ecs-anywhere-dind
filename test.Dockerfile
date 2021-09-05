FROM centos

LABEL __copyright__="(C) Guido Draheim, licensed under the EUPL" \
      __version__="1.5.4264"

ENV INDEX_PHP="/var/www/html/index.php"
ARG USERNAME=testuser_ok
ARG PASSWORD=P@ssw0rd.1b89e38af6966558c1a1714e15828b9bfea996f91e6f
ARG TESTPASS=P@ssw0rd.rwCh2gAEqgMXBUHwKtDQVD1oP2croTMLgtKr.9fUidQ.
ARG LISTEN=172.0.0.0/8
EXPOSE 80

RUN curl https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py > /usr/bin/systemctl
RUN yum install -y epel-release           psmisc
RUN yum repolist
RUN yum install -y httpd httpd-tools mariadb-server mariadb php python3
RUN echo "<?php phpinfo(); ?>" > ${INDEX_PHP}
RUN systemctl start mariadb -vvv \
  ; mysqladmin -uroot password ${TESTPASS} \
  ; echo "CREATE USER ${USERNAME} IDENTIFIED BY '${PASSWORD}'" | mysql -uroot -p${TESTPASS} \
  ; systemctl stop mariadb -vvv 



RUN systemctl enable mariadb
RUN systemctl enable httpd
CMD /usr/bin/systemctl