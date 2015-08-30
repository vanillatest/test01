#:
#	echo "$(/bin/grep -Eio "^[a-z0-9]+" Makefile)"
NAME := "vagrant fun"
VERSION := ".1"


help: .SILENT
	echo -e "targets:"
	for x in $$(/bin/grep -Eio "^[a-z0-9]+:" Makefile | tr -d ':'); do echo -e "- $$x"; done

viewsetup: 
	ansible -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory  -m setup all

status: 
	vagrant status

up: 
	vagrant up

reload: 
	vagrant reload

shutdown: 
	vagrant halt

down: shutdown

poweroff: 
	vagrant halt -f

provision: 
	ansible-playbook -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory  $$(/bin/grep "playbook" Vagrantfile | grep -Ev "^\s*\t*#" | cut -d'=' -f2| cut -d'"' -f2)

pretty: 
	find . -type f -name "*~" -exec rm -f {} +;

clear: clean

clean:  pretty
	vagrant halt -f
	vagrant destroy -f
	rm -rf .vagrant facts_json
	rm -f testinventory

.force: ;

.SILENT:
