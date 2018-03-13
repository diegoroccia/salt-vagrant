# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"

  config.vm.provision "shell", inline: <<-SHELL
     wget -q -O - https://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest/SALTSTACK-GPG-KEY.pub | sudo apt-key add -
     echo 'deb http://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest xenial main' >> /etc/apt/sources.list.d/saltstack.list
     apt-get -qq update
  SHELL

  (1..2).each do |i|
    config.vm.define "master#{i}" do |master1|
       master1.vm.hostname = "master#{i}"
       master1.vm.synced_folder "master/srv", "/srv/"
       master1.vm.synced_folder "master/etc", "/etc/salt/"
       master1.vm.provision "shell", inline: 'DEBIAN_FRONTEND=noninteractive apt-get -qq -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install salt-master'
    end
  end


  (1..3).each do |i|
    config.vm.define "minion#{i}" do |minion|
       minion.vm.hostname = "minion#{i}"
       minion.vm.synced_folder "minion/etc", "/etc/salt/"
       minion.vm.provision "shell", inline: 'DEBIAN_FRONTEND=noninteractive apt-get -qq -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install salt-minion'
    end
  end
end
