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
	/bin/bash ./cleantmp.sh

up: 
	vagrant up
	/bin/bash ./cleantmp.sh

reload: 
	vagrant reload
	/bin/bash ./cleantmp.sh

shutdown: 
	vagrant halt
	/bin/bash ./cleantmp.sh

down: shutdown
	/bin/bash ./cleantmp.sh

poweroff: 
	vagrant halt -f
	/bin/bash ./cleantmp.sh

provision: 
	ansible-playbook -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory  $$(/bin/grep "playbook" Vagrantfile | grep -Ev "^\s*\t*#" | cut -d'=' -f2| cut -d'"' -f2)

pretty: cleantmp
	find . -type f -name "*~" -exec rm -f {} +;

cleantemp: cleantmp
cleantmp:
	/bin/bash ./cleantmp.sh

clear: clean
clean:  pretty
	vagrant halt -f
	vagrant destroy -f
	rm -rf .vagrant facts_json
	rm -f testinventory
	/bin/bash ./cleantmp.sh


.force: ;

.SILENT:
