#!/bin/bash

# GUI prompt
if zenity --question --title="Daily Backup" --text="Do you want to backup Documents now?"; then
    # Count total files to backup
    total_files=$(find /home/anuradhe/Documents/ -type f \
        ! -path '*/.git/*' \
        ! -path '*/node_modules/*' | wc -l)
    
    # Run rsync with progress and pipe to zenity
    rsync -av --delete \
        --exclude='.git/' \
        --exclude='node_modules/' \
        --info=progress2 \
        /home/anuradhe/Documents/ /mnt/backup/Personal/ 2>&1 | \
    while IFS= read -r line; do
        # Extract percentage from rsync output
        if [[ $line =~ ([0-9]+)% ]]; then
            percent="${BASH_REMATCH[1]}"
            echo "$percent"
            echo "# Backing up: $line"
        fi
    done | zenity --progress \
        --title="Backup in Progress" \
        --text="Starting backup..." \
        --percentage=0 \
        --auto-close \
        --auto-kill
    
    # Check if backup was successful
    if [ $? -eq 0 ]; then
        zenity --info --title="Backup Complete" --text="Backup completed successfully."
    else
        zenity --error --title="Backup Failed" --text="Backup was cancelled or failed."
    fi
else
    zenity --info --title="Backup Skipped" --text="Backup skipped."
fi
