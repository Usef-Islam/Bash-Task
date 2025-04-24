#!/bin/bash

# === Configuration ===
SOURCE_DIR="/etc"
BACKUP_DIR="/var/backups/daily"
LOG_DIR="/var/log/daily_backup"
RETENTION_DAYS=7
LOG_RETENTION=5
EMAIL="root@localhost"

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
HOSTNAME=$(hostname)
BACKUP_FILE="$BACKUP_DIR/backup_$HOSTNAME_$DATE.tar.gz"
LOG_FILE="$LOG_DIR/backup_$DATE.log"
TMP_LOG="/tmp/backup_tmp.log"

mkdir -p "$BACKUP_DIR" "$LOG_DIR"

send_alert() {
    SUBJECT="[BACKUP FAILED] Backup on $HOSTNAME failed at $DATE"
    mail -s "$SUBJECT" "$EMAIL" < "$TMP_LOG"
}

rotate_logs() {
    ls -tp "$LOG_DIR"/*.log | grep -v '/$' | tail -n +$((LOG_RETENTION + 1)) | xargs -I {} rm -- {}
}

cleanup_backups() {
    find "$BACKUP_DIR" -type f -name "*.tar.gz" -mtime +$RETENTION_DAYS -exec rm -f {} \;
}

{
    echo "=== Starting backup: $DATE ==="
    echo "Backing up $SOURCE_DIR to $BACKUP_FILE"

    if tar -czf "$BACKUP_FILE" "$SOURCE_DIR"; then
        echo "Backup completed successfully."
    else
        echo "ERROR: Failed to create backup archive."
        send_alert
        exit 1
    fi

    echo "Cleaning up old backups..."
    cleanup_backups

    echo "Rotating logs..."
    rotate_logs

    echo "=== Backup completed: $(date +"%Y-%m-%d %H:%M:%S") ==="
} > "$TMP_LOG" 2>&1

cp "$TMP_LOG" "$LOG_FILE"
rm "$TMP_LOG"
