#!/bin/bash
sudo cp /vagrant/hostnames/hosts /etc/hosts
sudo yum install -y curl policycoreutils-python openssh-server
sudo systemctl enable sshd
sudo systemctl start sshd
sudo firewall-cmd --permanent --add-service=http
sudo systemctl reload firewalld
sudo yum install -y postfix
sudo systemctl enable postfix
sudo systemctl start postfix
wget -q --user "${USERNAME}" --password "${PASSWORD}" "https://nexus.di2e.net/nexus/content/repositories/Private_AFDCGSCICD_Releases/content/repositories/Releases/CIE/gitlab/gitlab-ce-8.16.4-ce.0.el7.x86_64.rpm"
sudo rpm -i "gitlab-ce-8.16.4-ce.0.el7.x86_64.rpm"
sudo yum install -y gitlab-ce
if [[ "$(ping -c 1 ca.cie.unclass.mil > /dev/null ; echo $?)" == 0 ]];
then
    sudo curl -o /etc/pki/ca-trust/source/anchors/myCA.pem --insecure --user vagrant:vagrant scp://ca.cie.unclass.mil/home/vagrant/myCA.pem
    sudo update-ca-trust extract
    sudo mkdir /etc/gitlab/ssl/
    sudo curl -o /etc/gitlab/ssl/gitlab.crt --insecure --user vagrant:vagrant scp://ca.cie.unclass.mil/home/vagrant/gitlab.crt
    sudo curl -o /etc/gitlab/ssl/gitlab.key --insecure --user vagrant:vagrant scp://ca.cie.unclass.mil/home/vagrant/gitlab.key
    sudo sed -i 's#external_url .*#external_url '"'"'https://gitlab.cie.unclass.mil'"'"'#' /etc/gitlab/gitlab.rb
    sudo sed -i "s/# nginx\['enable'\] = true/nginx\['enable'\] = true/" /etc/gitlab/gitlab.rb
    sudo sed -i "s/# nginx\['redirect_http_to_https'\] = false/nginx\['redirect_http_to_https'\] = true/" /etc/gitlab/gitlab.rb
    sudo sed -i "s-# nginx\['ssl_certificate'\] = \"/etc/gitlab/ssl/#{node\['fqdn'\]}.crt\"-nginx\['ssl_certificate'\] = \"/etc/gitlab/ssl/gitlab.crt\"-" /etc/gitlab/gitlab.rb
    sudo sed -i "s-# nginx\['ssl_certificate_key'\] = \"/etc/gitlab/ssl/#{node\['fqdn'\]}.key\"-nginx\['ssl_certificate_key'\] = \"/etc/gitlab/ssl/gitlab.key\"-" /etc/gitlab/gitlab.rb
    sudo sed -i "s,# nginx\['ssl_ciphers'\] = \"ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256\",nginx\['ssl_ciphers'\] = \"ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256\"," /etc/gitlab/gitlab.rb
else
    sudo sed -i 's#external_url .*#external_url '"'"'http://gitlab.cie.unclass.mil'"'"'#' /etc/gitlab/gitlab.rb
fi
sudo gitlab-ctl reconfigure