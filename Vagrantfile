# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'json'

Vagrant.configure("2") do |config|

  config.vm.box = "generic/ubuntu1604"

  MASTER_NODES = 1
  MINION_NODES = 1
  SUBNET = '172.28.128'
  SALT_VERSION = '2018.3'

  config.vm.provider "virtualbox" do |v|
    v.linked_clone = true
    v.memory = 1024
    v.cpus = 1
  end

  masters = Array.new

  (1..MASTER_NODES.to_i).each do |i|
    config.vm.define "master#{i}" do |master|
       master.vm.hostname = "master#{i}.local"
       masters << "#{SUBNET}.#{10+i}" 
       master.vm.synced_folder "srv", "/srv/", type: "rsync"
       master.vm.network :private_network, :ip => "#{SUBNET}.#{10+i}"
       master.vm.provision :salt do |salt|
          salt.install_master = true
          salt.master_key = "master/master.pem"
          salt.master_pub = "master/master.pub"
          salt.master_config = "master/config"
	  salt.version = SALT_VERSION
          salt.no_minion  = true
       end
       master.vm.provision "shell", inline: "echo '*' | sudo tee -a /etc/salt/autosign.conf; sudo systemctl restart salt-master"
    end
  end

  minion_config =  { :master => masters }

  (1..MINION_NODES.to_i).each do |i|
    config.vm.define "minion#{i}" do |minion|
       minion.vm.hostname = "minion#{i}.local"
       minion.vm.network :private_network, :ip => "#{SUBNET}.#{20+i}"
       config.vm.provision :salt do |salt|
          salt.install_master = false
          salt.minion_json_config = minion_config.to_json
	  salt.version = SALT_VERSION
	  salt.run_highstate = true
       end
    end
  end

end
