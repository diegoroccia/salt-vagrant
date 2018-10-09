# Test Salt Environment

Vagrantfile to start a salt setup. 
you can choose the number of syndics and minions. 
All the syndics will share the same key and the minions will be configured in multimaster mode (connected to all the syndics)
on the master node salt apis will be installed and the port 8000 (no SSL) will be exposed on the host

## TODO: 

* master IP is hardcoded, must depend on the subnet configuration
* install a minion cache that supports multimaster ( consul/redis? )

## Requirements

* vagrant
* virtualbox/libvirt

## Configuration

To be changed in the env.yml file

* salt_version (defaut='stable 2018.3')
* subnet  (default='172.28.128')
* syndic_nodes (default=1)
* minion_nodes (default=2)
* vagrant_box (default='generic/ubuntu1604')

### Minion configuration

before provisioning the VMs you can edit all the `*/config` files to add custom customizations

the list of masters will be injected into the configuration during the provisioning phase

## Usage

### to spin up the VMs

```
vagrant up [--provider=<provider>]
```

this will spin up all the VM. install salt, accept the keys and expose salt-api on port 8000 on the host.

### to connect to a node

```
vagrant ssh <nodename>
```

default nodename has been set to master (the MoM node)

### using salt-api endpoint

the endpoint is exposed on the host machine on port 8000. E.g.

```
➜   curl -sS http://localhost:8000/login \
      -c ~/cookies.txt \
      -H 'Accept: application/x-yaml' \
      -d username=vagrant \
      -d password=vagrant \
      -d eauth=pam

```

### to destroy the VMs

```
vagrant destroy
```

