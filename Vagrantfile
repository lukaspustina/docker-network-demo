# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.require_version ">= 1.4.0"

BOX_NAME = "docker-network-demo"

Vagrant.configure("2") do |config|
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  config.vm.define BOX_NAME do |t| end

  config.vm.box = "Ubuntu 14.04"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/trusty/20140904/trusty-server-cloudimg-amd64-vagrant-disk1.box"

  config.vm.hostname = "#{BOX_NAME}.localdomain"
  config.vm.network "private_network", ip: "10.2.0.10", netmask: "255.255.0.0"
  config.vm.provider :virtualbox do |vbox|
    vbox.name = BOX_NAME
    vbox.memory = 1024
  end

  config.vm.provision :shell, :inline => 'echo DOCKER_OPTS="-bip=10.2.0.10/16" > /etc/default/docker'
  config.vm.provision :shell, :inline => '
  echo ip addr del 10.2.0.10/16 dev eth1 > /etc/rc.local
  echo ip link set eth1 master docker0 >> /etc/rc.local
  echo service docker restart >> /etc/rc.local
  chmod +x /etc/rc.local 2> /dev/null'
  config.vm.provision "docker", version: "1.2.0"
  config.vm.provision :shell, :inline => '/etc/rc.local'
  config.vm.provision :shell, :inline => "mkdir -p /var/lib/cloud/instance; touch /var/lib/cloud/instance/locale-check.skip"
  config.vm.provision :shell, :inline => "apt-get install -y arping"
end

