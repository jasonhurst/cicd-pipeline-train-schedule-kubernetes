#!/bin/bash
sudo yum -y install java-1.8.0-openjdk
sudo wget -q --user "${USERNAME}" --password "${PASSWORD}" https://nexus.di2e.net/nexus/content/repositories/Private_AFDCGSCICD_Releases/content/repositories/Releases/CIE/jenkins/jenkins-2.156-1.1.noarch.rpm
sudo rpm -i jenkins-2.156-1.1.noarch.rpm
sudo yum install jenkins
sudo systemctl start jenkins