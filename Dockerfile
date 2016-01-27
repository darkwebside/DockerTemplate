# "ported" by Adam Miller <maxamillion@fedoraproject.org> from
#   https://github.com/fedora-cloud/Fedora-Dockerfiles
#
# Originally written for Fedora-Dockerfiles by
#   scollier <scollier@redhat.com>

FROM centos:centos6
MAINTAINER The CentOS Project <cloud-ops@centos.org>

RUN yum -y install wget


RUN rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm
RUN yum -y update; yum clean all
RUN yum -y install epel-release httpd  yum clean all

ADD ./httpd-24.sh /httpd-24.sh
RUN chmod 755 /httpd-24.sh
RUN /httpd-24.sh


RUN yum -y install mysql-server mysql pwgen supervisor bash-completion psmisc net-tools; yum clean all
#RUN yum install -y php php-mysql php-devel php-gd php-pecl-memcache php-pspell php-snmp php-xmlrpc php-xml phpmyadmin
RUN yum -y install php56w-common php56w-opcache php56w-cli php56w-fpm php56w-mysql php56w-pgsql php56w-xml


# install sshd
RUN yum install -y openssh-server openssh-clients passwd

RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN sed -ri 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config && echo 'root:changeme' | chpasswd

ADD ./phpinfo.php /var/www/html/

ADD ./start.sh /start.sh
ADD ./config_mysql.sh /config_mysql.sh
ADD ./supervisord.conf /etc/supervisord.conf
VOLUME /var/www/html
# RUN echo %sudo	ALL=NOPASSWD: ALL >> /etc/sudoers

RUN chmod 755 /start.sh
RUN chmod 755 /config_mysql.sh
RUN /config_mysql.sh

EXPOSE 22 80 3306

CMD ["/bin/bash", "/start.sh"]
