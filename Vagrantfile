# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'erb'

Vagrant.configure("2") do |config|

  template = ERB.new File.read("minion/config.erb")

  MASTER_NODES = ENV['MASTER_NODES'] || 1
  MINION_NODES = ENV['MINION_NODES'] || 2

  config.vm.provider "virtualbox" do |v|
    v.linked_clone = true
    v.memory = 1024
    v.cpus = 1
  end

  config.vm.box = "ubuntu/xenial64"

  config.vm.network "private_network", type: "dhcp"

  masters = Array.new

  (1..MASTER_NODES.to_i).each do |i|
    config.vm.define "master#{i}" do |master|
       master.vm.hostname = "master#{i}"
       master.vm.synced_folder "srv", "/srv/"
       master.vm.provision :salt do |salt|
          salt.install_master = true
	  salt.master_key = "master/master.pem"
	  salt.master_pub = "master/master.pub"
	  salt.no_minion  = true
       end
       masters << "master#{i}" 
    end
  end

  (1..MINION_NODES.to_i).each do |i|
    config.vm.define "minion#{i}" do |minion|
       result = template.result(binding)
       outputFile = File.new('minion/config',File::CREAT|File::TRUNC|File::RDWR)
       outputFile.write(result)
       outputFile.close
       minion.vm.hostname = "minion#{i}"
       config.vm.provision :salt do |salt|
          salt.install_master = false
          salt.minion_config = 'minion/config'
       end
    end
  end

end
