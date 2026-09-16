#!/bin/bash

cd "$(dirname "$0")/.." || exit 1

check_failure() {
    if [ $? -ne 0 ]; then
        echo "$1"
        exit 1
    fi
}

check_config_dir() {
    if [ ! -d "config" ]; then
        echo "Config directory does not exist."
        exit 1
    fi
}

check_config_dir

mkdir -p backups

check_failure "Failed to create backups directory."

tar -czf backups/config-$(date +%Y-%m-%d-%H-%M-%S).tar.gz config

check_failure "Backup failed."

echo "Backup completed successfully."
exit 0