# Backup Manager

To install...

    sudo make install

Configuration files are in config.


## Backups

Add backups to config/backups

    <repository>    <source_path>

### Examples

    minecraft       /srv/srvr/farm/minecraft-60
    minecraft       /srv/srvr/farm/minecraft-61
    sftp:mark@ws-01 /home/mark/Pictures

Remote repositories will automatically use the hostname. Make sure SSH is configured to work automatically


## Run it


To run it, use the backup-manager command which comes from the resticmgr python module.

    backup-manager backup


