# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.provider "virtualbox" do |v|
    v.linked_clone = true
    v.memory = 1024
    v.cpus = 1
  end

  config.vm.box = "ubuntu/xenial64"

  config.vm.provision "shell", inline: <<-SHELL
     wget -q -O - https://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest/SALTSTACK-GPG-KEY.pub | sudo apt-key add -
     echo 'deb http://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest xenial main' >> /etc/apt/sources.list.d/saltstack.list
     apt-get -qq update
  SHELL

  (1..2).each do |i|
    config.vm.define "master#{i}" do |master|
       master.vm.hostname = "master#{i}"
       master.vm.synced_folder "srv", "/srv/"
       master.vm.provision :salt do |salt|
          salt.install_master = true
	  salt.master_key = "master/master.pem"
	  salt.master_pub = "master/master.pub"
       end
    end
  end


  (1..3).each do |i|
    config.vm.define "minion#{i}" do |minion|
       minion.vm.hostname = "minion#{i}"
       config.vm.provision :salt do |salt|
          salt.install_master = false
	  salt.minion_config = "minion/config"
       end
    end
  end

end
