# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'erb'

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/xenial64"


  MASTER_NODES = ENV['MASTER_NODES'] || 1
  MINION_NODES = ENV['MINION_NODES'] || 2
  SUBNET = ENV['VM_SUBNET'] || '172.28.128'

  config.vm.provider "virtualbox" do |v|
    v.linked_clone = true
    v.memory = 1024
    v.cpus = 1
  end

  template = ERB.new File.read("templates/minion-config.erb")
  masters = Array.new

  (1..MASTER_NODES.to_i).each do |i|
    config.vm.define "master#{i}" do |master|
       master.vm.hostname = "master#{i}.local"
       master.vm.synced_folder "srv", "/srv/"
       master.vm.network :private_network, :ip => "#{SUBNET}.#{10+i}"
       master.vm.provision :salt do |salt|
          salt.install_master = true
	  salt.master_key = "master/master.pem"
	  salt.master_pub = "master/master.pub"
	  salt.no_minion  = true
       end
       masters << "#{SUBNET}.#{10+i}" 
    end
  end

  (1..MINION_NODES.to_i).each do |i|
    config.vm.define "minion#{i}" do |minion|
       result = template.result(binding)
       outputFile = File.new('templates/minion-config',File::CREAT|File::TRUNC|File::RDWR)
       outputFile.write(result)
       outputFile.close
       minion.vm.hostname = "minion#{i}.local"
       minion.vm.network :private_network, :ip => "#{SUBNET}.#{20+i}"
       config.vm.provision :salt do |salt|
          salt.install_master = false
          salt.minion_config = 'templates/minion-config'
       end
    end
  end

end
