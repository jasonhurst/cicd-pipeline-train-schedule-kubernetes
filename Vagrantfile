# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
#

servers=[
  {
    :hostname => "k8master",
    :ip => "192.168.100.14",
    :box => "bento/centos-7.3",
    :ram => 1024,
    :cpu => 2,
    :hport => 8085,
    :gport => 8080
  },
  {
    :hostname => "k8node1",
    :ip => "192.168.100.15",
    :box => "bento/centos-7.3",
    :ram => 1024,
    :cpu => 2,
    :hport => 8086,
    :gport => 8080
  },
  {
    :hostname => "k8node2",
    :ip => "192.168.100.16",
    :box => "bento/centos-7.3",
    :ram => 1024,
    :cpu => 2,
    :hport => 8087,
    :gport => 8080
  },
  {
    :hostname => "ansible",
    :ip => "192.168.100.10",
    :box => "bento/centos-7.3",
    :ram => 1024,
    :cpu => 2,
    :hport => 8081,
    :gport => 8080
  },
  {
    :hostname => "gitlab",
    :ip => "192.168.100.11",
    :box => "bento/centos-7.3",
    :ram => 2048,
    :cpu => 2,
    :hport => 8082,
    :gport => 80
  },
  {
    :hostname => "jenkins",
    :ip => "192.168.100.19",
    :box => "bento/centos-7.3",
    :ram => 1024,
    :cpu => 2,
    :hport => 8090,
    :gport => 8080
  }
]


Vagrant.configure(2) do |config|
    servers.each do |machine|
        config.vm.define machine[:hostname] do |node|
            node.vm.box = machine[:box]
            node.vm.hostname = machine[:hostname]
            node.vm.network "private_network", ip: machine[:ip]
            if  machine[:ip2] != nil
              node.vm.network "private_network", ip: machine[:ip2]
            end
            node.vm.network "forwarded_port", host: machine[:hport], guest: machine[:gport]
              node.vm.provider "virtualbox" do |vb|
                vb.customize ["modifyvm", :id, "--memory", machine[:ram]]
                vb.customize ["modifyvm", :id, "--cpus", machine[:cpu]]
                if machine[:box] != "vsphere"
                  vb.customize ["storageattach", :id, 
                  "--storagectl", "IDE Controller", 
                  "--port", "0", "--device", "1", 
                  "--type", "dvddrive", 
                  "--medium", "emptydrive"]
                end
              end
            node.vm.provision "shell", 
            path: machine[:hostname] + ".sh", 
            env: {"USERNAME"=>ENV['DI2E_USERNAME'], "PASSWORD"=>ENV['DI2E_PASSWORD']}
        end
    end
end
