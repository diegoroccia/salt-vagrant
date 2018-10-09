# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'json'
require 'yaml'

env = YAML.load_file('env.yml')

VAGRANT_BOX = env['vagrant_box'] or "generic/ubuntu1604"
MASTER_NODES = env['master_nodes'].to_i or 1
SYNDIC_NODES = env['syndic_nodes'].to_i or 1
MINION_NODES = env['minion_nodes'].to_i or 1
SUBNET = env['subnet'] or '172.28.128'
SALT_VERSION = env['salt_version'] or 'stable 2018.3'

minion_config = YAML.load_file("minion/config")

Vagrant.configure("2") do |config|
 
  config.ssh.forward_agent = true

  # Fix for DNSSEC on ubuntu bionic

  config.vm.provision :shell, inline: 'sudo sed -i "s/DNSSEC=yes/DNSSEC=no/g" /etc/systemd/resolved.conf; sudo systemctl restart systemd-resolved.service'
  config.vm.box = VAGRANT_BOX

  config.vm.define "master", primary: true do |master|
     master.vm.hostname = "master.local"
     master.vm.network :private_network, :ip => "#{SUBNET}.5"
     master.vm.network "forwarded_port",  guest: 8000, host: 8000
     master.vm.provision :salt do |salt|
        salt.bootstrap_options = "-x python3 -p salt-api"
        salt.version = SALT_VERSION
        salt.install_master = true
        salt.master_config = "master/config"
        salt.no_minion = true
     end
     master.vm.provision :shell, inline: 'sudo systemctl start salt-api'
  end

  syndics = Array.new

  (1..SYNDIC_NODES.to_i).each do |i|
    config.vm.define "syndic#{i}" do |syndic|
       syndic.vm.hostname = "syndic#{i}.local"
       syndics << "#{SUBNET}.#{10+i}" 
       syndic.vm.synced_folder "srv", "/srv/" , type: "rsync"
       syndic.vm.network :private_network, :ip => "#{SUBNET}.#{10+i}"
       syndic.vm.provision :salt do |salt|
	  salt.bootstrap_options = "-x python3"
	  salt.version = SALT_VERSION
          salt.install_syndic = true
          salt.master_key = "syndic/master.pem"
          salt.master_pub = "syndic/master.pub"
          salt.master_config = "syndic/config"
          salt.minion_config = "syndic/minion_config"
       end
    end
  end

  minion_config[:master] = syndics 

  (1..MINION_NODES.to_i).each do |i|
    config.vm.define "minion#{i}" do |minion|
       minion.vm.hostname = "minion#{i}.local"
       minion.vm.network :private_network, :ip => "#{SUBNET}.#{20+i}"
       config.vm.provision :salt do |salt|
	  salt.bootstrap_options = "-x python3"
	  salt.version = SALT_VERSION
          salt.install_master = false
          salt.minion_json_config = minion_config.to_json
	  salt.run_highstate = false
       end
    end
  end

end
