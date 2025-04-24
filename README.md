# Bash-Task
# Daily System Backup Script

## Overview
This script automates daily backups of a specified directory, rotates old backups and logs, and sends email alerts on failure.

## Features
- Configurable backup source and retention
- Compressed `.tar.gz` backup files
- Log rotation
- Cron job compatible

## Setup Instructions

1. **Configure the Script:**
   Edit the top of `daily_backup.sh` to set:
   - `SOURCE_DIR`
   - `BACKUP_DIR`
   - `RETENTION_DAYS`
   - `EMAIL` (uses local Postfix)

2. **Permissions:**
   Make the script executable:
   ```bash
   chmod +x daily_backup.sh
