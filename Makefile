
ifndef INSTALL_PATH
INSTALL_PATH="/data/backups"
endif


.PHONY: restic scripts config python manager venv install clean

install: restic scripts config manager

scripts: /usr/bin/restictl /usr/bin/restic-init /usr/bin/restic-backup /usr/bin/restic-manager /usr/bin/restic-reponame

config: /data/backups /data/backups/.restic-backups /data/backups/.restic-environment /data/backups/.restic-password /data/backups/.restic-repositories

restic:
	sudo apt install -y restic

manager: venv /usr/bin/restic-manager

/usr/bin/restic-manager:
	cp files/usr/bin/restic-manager /usr/bin/restic-manager
	chmod +x /usr/bin/restic-manager

venv: python
	cd /data/backups ; sudo ./py/install.sh

python:
	mkdir -p /data/backups/py ;
	cp ./requirements.txt ./setup.py /data/backups/py ;
	cp -R ./resticmgr /data/backups/py/ ; 
	chown -R root:restic /data/backups/py ;
	cp install.sh /data/backups/py/install.sh;
	chmod +x /data/backups/py/install.sh ;

/usr/bin/restictl:
	cp files/usr/bin/restictl /usr/bin/restictl
	chmod +x /usr/bin/restictl

/usr/bin/restic-init:
	cp files/usr/bin/restic-init /usr/bin/restic-init
	chmod +x /usr/bin/restic-init

/usr/bin/restic-backup:
	cp files/usr/bin/restic-backup /usr/bin/restic-backup
	chmod +x /usr/bin/restic-backup

/usr/bin/restic-reponame:
	cp files/usr/bin/restic-reponame /usr/bin/restic-reponame
	chmod +x /usr/bin/restic-reponame

/data/backups:
	mkdir -p /data/backups
	chown -R root:restic /data/backups

/data/backups/.restic-backups:
	cp config/backups /data/backups/.restic-backups
	chown root:restic /data/backups/.restic-backups

/data/backups/.restic-environment:
	cp config/environment /data/backups/.restic-environment
	chown root:restic /data/backups/.restic-environment

/data/backups/.restic-password:
	cp config/password /data/backups/.restic-password
	chown root:restic /data/backups/.restic-password

/data/backups/.restic-repositories:
	cp config/repositories /data/backups/.restic-repositories
	chown root:restic /data/backups/.restic-repositories

reconfig: clean-config config

rescript: clean-scripts scripts

clean: clean-python clean-cache clean-config clean-scripts

clean-config:
	rm -f /data/backups/.restic-backups /data/backups/.restic-environment /data/backups/.restic-password /data/backups/.restic-repositories

clean-scripts:
	rm -f /usr/bin/restictl /usr/bin/restic-init /usr/bin/restic-backup /usr/bin/restic-manager /usr/bin/restic-reponame

clean-cache:
	rm -rf /data/backups/.cache

clean-python:
	rm -rf /data/backups/venv /data/backups/py



