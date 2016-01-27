#!/bin/bash

__getRepo(){
echo "Instalando Apache 2.4"
cd /etc/yum.repos.d/
wget http://repos.fedorapeople.org/repos/jkaluza/httpd24/epel-httpd24.repo
yum update
yum install httpd24.x86_64
}

__checkTheThing(){

/opt/rh/httpd24/root/usr/sbin/httpd -version

}

__getRepo
__checkTheThing