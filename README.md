# Test Salt Environment

Vagrantfile to start a salt setup. 
you can choose the number of syndics and minions. 
All the syndics will share the same key and the minions will be configured in multimaster mode (connected to all the syndics)
on the master node salt apis will be installed and the port 8000 (no SSL) will be exposed on the host

## Requirements

* vagrant
* virtualbox

it should work also with libvirt and vmware desktop, since the box I used supports all three, but I didn't check.


## Configuration

To be changed in the env.yml file

* salt_version (defaut='2018.3')
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
vagrant up
```

this will spin up all the VM. install salt, accept the keys, and run highstate on all the minions

### to connect to a node

```
vagrant ssh <nodename>
```

default nodename has been set to mom

### to destroy the VMs

```
vagrant destroy
```

