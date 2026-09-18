#!/bin/bash

cd "$(dirname "$0")" || exit 1

KEEPDAYS=7
BACKUP_DIR="backups"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a $BACKUP_DIR/backup.log
}

check_failure() {
    if [ $? -ne 0 ]; then
        log "ERROR: $1"
        exit 1
    fi
}

check_config_dir() {
    if [ ! -d "config" ]; then
        log "ERROR: Config directory does not exist."
        exit 1
    fi
}

clean_backups() {
    OLD_BACKUPS=$(find "$BACKUP_DIR" \
        -type f \
        -name "config-*.tar.gz" \
        -mtime +$KEEPDAYS \
        -print)

    if [ -z "$OLD_BACKUPS" ]; then
        log "INFO: No old backups to clean."
        return 0
    fi

    find "$BACKUP_DIR" \
        -type f \
        -name "config-*.tar.gz" \
        -mtime +$KEEPDAYS \
        -delete

    if [ $? -ne 0 ]; then
        log "INFO: Backup cleanup failed."
        return 1
    fi

    log "INFO: Old backups cleaned successfully."

}

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a $BACKUP_DIR/backup.log
}

check_config_dir

mkdir -p $BACKUP_DIR

check_failure "Failed to create backups directory."

tar -czf $BACKUP_DIR/config-$(date +%Y-%m-%d-%H-%M-%S).tar.gz config

check_failure "Backup archive creation failed."

clean_backups

check_failure "Backup cleanup failed."

log "INFO: Backup completed successfully."

exit 0