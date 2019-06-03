#!/bin/bash
sudo cp /vagrant/hostnames/hosts /etc/hosts
if [[ "$(ping -c 1 ca.cie.unclass.mil > /dev/null ; echo $?)" == 0 ]];
then
    sudo curl -o /etc/pki/ca-trust/source/anchors/myCA.pem --insecure --user vagrant:vagrant scp://ca.cie.unclass.mil/home/vagrant/myCA.pem
    sudo update-ca-trust extract
fi
sudo yum -y install java-1.8.0-openjdk
sudo wget -q --user "${USERNAME}" --password "${PASSWORD}" https://nexus.di2e.net/nexus/content/repositories/Private_AFDCGSCICD_Releases/content/repositories/Releases/CIE/jenkins/jenkins-2.156-1.1.noarch.rpm
sudo rpm -i jenkins-2.156-1.1.noarch.rpm
sudo yum install jenkins
sudo systemctl start jenkins