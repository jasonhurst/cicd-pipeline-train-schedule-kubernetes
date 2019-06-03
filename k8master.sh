sudo cp /vagrant/hostnames/hosts /etc/hosts
if [[ "$(ping -c 1 ca.cie.unclass.mil > /dev/null ; echo $?)" == 0 ]];
then
    sudo curl -o /etc/pki/ca-trust/source/anchors/myCA.pem --insecure --user vagrant:vagrant scp://ca.cie.unclass.mil/home/vagrant/myCA.pem
    sudo update-ca-trust extract
fi