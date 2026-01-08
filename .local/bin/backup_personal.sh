#!/bin/bash

# GUI prompt
if zenity --question --title="Daily Backup" --text="Do you want to backup Documents now?"; then
    rsync -av --delete \
        --exclude='.git/' \
        --exclude='node_modules/' \
        /home/anuradhe/Documents/ /mnt/backup/Personal/
    zenity --info --title="Backup Complete" --text="Backup completed successfully."
else
    zenity --info --title="Backup Skipped" --text="Backup skipped."
fi

