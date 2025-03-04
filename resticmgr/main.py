
import subprocess
import time
from plumbum import local as sh, FG
from os.path import dirname, join, exists
from os import environ as env
from sys import argv as args
import sys
import schedule


def _die(msg):
    print(f"[ERROR] {msg}")
    sys.exit(1)

def _info(msg):
    print(f"[INFO]  {msg}")

def parse_backup_config(entry_string):
    parts = entry_string.split()
    entry = {}
    entry['name'] = parts[0]
    entry['source'] = parts[1]
    return entry

def load_backup_config():
    backups_config = env["RESTIC_BACKUPS"]
    if not exists(backups_config):
        _die(f"Backup config file not found: {backups_config}")
    with open(backups_config, 'r') as fd:
        return [parse_backup_config(line) for line in fd.readlines()]

def maybe_init(cfg):
    repositories = env['RESTIC_REPOSITORIES']
    repo_name = cfg['name']
    _info(f"Initializing repo: {repo_name}")
    try:
        sh["restic-init"][repo_name]()
    except Error as e:
        _info("Failed to init repo. Hopefully it already exists.")


def do_backup(cfg):
    maybe_init(cfg)
    name = cfg['name']
    source = cfg['source']
    _info(f'Backing up "{source}" to repo {name}')
    sh["restic-backup"][name][source] & FG

def backup():
    _info("creating backups.")
    backup_config = env["RESTIC_BACKUPS"]
    _info(f"reading backup config from: {backup_config}")
    for entry in load_backup_config():
        do_backup(entry)

def list_backup_configs():
    _info("Configured backups")
    for entry in load_backup_config():
        name = entry['name']
        source = entry['source']
        print(f" - name: {name}, source: {source}")

def list_repo_objects():
    if len(args) < 4:
        _die("list_repo_objects: Not enough arguments")
    repo = args[2]
    object_type = args[3]
    sh["restictl"]["list"]["--repo"][repo][object_type] & FG

def main():
    print("[Restic Manager]")
    action = "config"
    if len(args) > 1:
        action = args[1]

    if action == "config":
        list_backup_configs()
    elif action == "backup":
        backup()
    elif action == "list":
        list_repo_objects()
    elif action == "init":
        for cfg in load_backup_config():
            maybe_init(cfg)



