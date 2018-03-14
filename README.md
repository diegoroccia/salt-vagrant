# Test Salt Environment

Vagrantfile to start a salt setup. you can choose the number of masters and minions. All the masters will share the same key and the minions will be configured in multimaster mode (connected to all the masters)

## Configuration

* MASTER_NODES [ default=1 ]
* MINION_NODES [ default=2 ]

## Usage

` MASTER_NODES=2 MINION_NODES=3 vagrant up `
