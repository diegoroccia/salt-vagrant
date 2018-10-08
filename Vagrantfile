# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'json'
require 'yaml'

env = YAML.load_file('env.yml')

VAGRANT_BOX = env['vagrant_box'] or "generic/ubuntu1604"
MASTER_NODES = env['master_nodes'].to_i or 1
SYNDIC_NODES = env['master_nodes'].to_i or 1
MINION_NODES = env['minion_nodes'].to_i or 1
SUBNET = env['subnet'] or '172.28.128'
SALT_VERSION = env['salt_version'] or '2018.3'

minion_config = YAML.load_file("minion/config")

Vagrant.configure("2") do |config|
 
  config.ssh.forward_agent = true

  config.vm.box = VAGRANT_BOX

  config.vm.provider "virtualbox" do |v|
    v.linked_clone = true
    v.memory = 1024
    v.cpus = 1
  end

  config.vm.define "master", primary: true do |master|
     master.vm.hostname = "master.local"
     master.vm.network :private_network, :ip => "#{SUBNET}.5"
     master.vm.provision :salt do |salt|
        salt.install_master = true
        salt.master_config = "master/config"
        salt.version = SALT_VERSION
        salt.no_minion = true
     end
  end

  syndics = Array.new

  (1..SYNDIC_NODES.to_i).each do |i|
    config.vm.define "syndic#{i}" do |syndic|
       syndic.vm.hostname = "syndic#{i}.local"
       syndics << "#{SUBNET}.#{10+i}" 
       syndic.vm.synced_folder "srv", "/srv/"
       syndic.vm.network :private_network, :ip => "#{SUBNET}.#{10+i}"
       syndic.vm.provision :salt do |salt|
          salt.install_syndic = true
          salt.master_key = "syndic/master.pem"
          salt.master_pub = "syndic/master.pub"
          salt.master_config = "syndic/config"
          salt.minion_config = "syndic/minion_config"
	  salt.version = SALT_VERSION
       end
    end
  end

  minion_config[:master] = syndics 

  (1..MINION_NODES.to_i).each do |i|
    config.vm.define "minion#{i}" do |minion|
       minion.vm.hostname = "minion#{i}.local"
       minion.vm.network :private_network, :ip => "#{SUBNET}.#{20+i}"
       config.vm.provision :salt do |salt|
          salt.install_master = false
          salt.minion_json_config = minion_config.to_json
	  salt.version = SALT_VERSION
	  salt.run_highstate = false
       end
    end
  end

end
