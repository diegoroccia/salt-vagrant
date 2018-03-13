# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.network "private_network", type: "dhcp"

  config.vm.provision "shell", inline: <<-SHELL
     wget -q -O - https://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest/SALTSTACK-GPG-KEY.pub | sudo apt-key add -
     echo 'deb http://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest xenial main' >> /etc/apt/sources.list.d/saltstack.list
     apt-get -qq update
  SHELL

  config.vm.define "master1" do |master1|
     master1.vm.provision "shell", inline: 'DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install -qqy salt-master'
     master1.vm.synced_folder "master/srv", "/srv/"
     master1.vm.synced_folder "master/etc", "/etc/salt/"
     master1.vm.hostname = "master1"
  end

  config.vm.define "master2" do |master2|
     master2.vm.provision "shell", inline: 'DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install -qqy salt-master'
     master2.vm.synced_folder "master/srv", "/srv/"
     master2.vm.synced_folder "master/etc", "/etc/salt/"
     master2.vm.hostname = "master2"
  end

  config.vm.define "minion" do |minion|
     minion.vm.provision "shell", inline: 'DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install -qqy salt-minion'
     minion.vm.synced_folder "minion/etc", "/etc/salt/"
     minion.vm.hostname = "minion"
  end

end
