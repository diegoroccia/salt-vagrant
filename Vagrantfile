# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  MASTER_NODES = ENV['MASTER_NODES'] || 1
  MINION_NODES = ENV['MINION_NODES'] || 2

  config.vm.provider "virtualbox" do |v|
    v.linked_clone = true
    v.memory = 1024
    v.cpus = 1
  end

  config.vm.box = "ubuntu/xenial64"

  config.vm.network "private_network", type: "dhcp"

  (1..(MASTER_NODES.to_i + 1)).each do |i|
    config.vm.define "master#{i}" do |master|
       master.vm.hostname = "master#{i}"
       master.vm.synced_folder "srv", "/srv/"
       master.vm.provision :salt do |salt|
          salt.install_master = true
	  salt.master_key = "master/master.pem"
	  salt.master_pub = "master/master.pub"
	  salt.no_minion  = true
       end
    end
  end


  (1..(MINION_NODES.to_i + 1)).each do |i|
    config.vm.define "minion#{i}" do |minion|
       minion.vm.hostname = "minion#{i}"
       config.vm.provision :salt do |salt|
          salt.install_master = false
	  salt.minion_config = "minion/config"
       end
    end
  end

end
