# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'erb'

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/xenial64"

  MASTER_NODES = 1
  MINION_NODES = 2
  SUBNET = '172.28.128'

  config.vm.provider "virtualbox" do |v|
    v.linked_clone = true
    v.memory = 1024
    v.cpus = 1
  end

  template = ERB.new File.read("minion/config.erb")
  masters = Array.new

    config.vm.define "master1", primary: true do |master|
       master.vm.hostname = "master1.local"
       masters << "#{SUBNET}.11" 
       master.vm.synced_folder "srv", "/srv/"
       master.vm.network :private_network, :ip => "#{SUBNET}.11"
       master.vm.provision :salt do |salt|
          salt.install_master = true
	  salt.master_key = "master/master.pem"
	  salt.master_pub = "master/master.pub"
	  salt.master_config = "master/config"
	  salt.no_minion  = true
       end
       master.vm.provision "shell", inline: "echo '*' | sudo tee -a /etc/salt/autosign.conf; sudo systemctl restart salt-master"
    end

  if MASTER_NODES > 1
    (2..MASTER_NODES.to_i).each do |i|
      config.vm.define "master#{i}" do |master|
         master.vm.hostname = "master#{i}.local"
         masters << "#{SUBNET}.#{10+i}" 
         master.vm.synced_folder "srv", "/srv/"
         master.vm.network :private_network, :ip => "#{SUBNET}.#{10+i}"
         master.vm.provision :salt do |salt|
            salt.install_master = true
            salt.master_key = "master/master.pem"
            salt.master_pub = "master/master.pub"
	    salt.master_config = "master/config"
            salt.no_minion  = true
         end
         master.vm.provision "shell", inline: "echo '*' | sudo tee -a /etc/salt/autosign.conf; sudo systemctl restart salt-master"
      end
    end
  end

  (1..MINION_NODES.to_i).each do |i|
    config.vm.define "minion#{i}" do |minion|
       result = template.result(binding)
       outputFile = File.new("minion/config",File::CREAT|File::TRUNC|File::RDWR)
       outputFile.write(result)
       outputFile.close
       minion.vm.hostname = "minion#{i}.local"
       minion.vm.network :private_network, :ip => "#{SUBNET}.#{20+i}"
       config.vm.provision :salt do |salt|
          salt.install_master = false
          salt.minion_config = "minion/config"
	  salt.run_highstate = true
       end
    end
  end

end
