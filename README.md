# Test Salt Environment

Vagrantfile to start a salt setup. you can choose the number of masters and minions. All the masters will share the same key and the minions will be configured in multimaster mode (connected to all the masters)

## Requirements

* vagrant
* virtualbox

it should work also with KVM but I didn't check.


## Configuration

To be changed in the Vagrantfile

* MASTER_NODES 
* MINION_NODES 
* VM_SUBNET 

## Usage

### to spin up the VMs

```
vagrant up
```

this will spin up all the VM and run highstate on all the minions

### to connect to a node

```
vagrant ssh <nodename>
```

default nodename has been set to master1

### to destroy the VMs

```
vagrant destroy
```

