#!/bin/bash
sudo cp /vagrant/hostnames/hosts /etc/hosts
if [[ "$(ping -c 1 ca.cie.unclass.mil > /dev/null ; echo $?)" == 0 ]];
then
    sudo curl -o /etc/pki/ca-trust/source/anchors/myCA.pem --insecure --user vagrant:vagrant scp://ca.cie.unclass.mil/home/vagrant/myCA.pem
    sudo update-ca-trust extract
fi
sudo yum install -y ansible
sudo yum install -y vim
sudo yum install -y epel-release 
sudo yum install -y python-pip
sudo pip install --upgrade pip
sudo pip install "pywinrm>=0.2.2"
sudo cp -f /vagrant/ansible-setup/hosts /etc/ansible/hosts
sudo cp -f /vagrant/ansible-setup/ansible.cfg /etc/ansible/ansible.cfg
ansible-playbook /vagrant/kubernetes-setup/master-playbook.yml
ansible-playbook /vagrant/kubernetes-setup/node-playbook.yml