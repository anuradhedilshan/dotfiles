#!/bin/bash

# ==============================================================================
#  IMAP MIGRATION SCRIPT (Bluehost -> AWS WorkMail)
#  Safe Copy Only | 5-Year Limit | Full Folder Sync
# ==============================================================================

# --- CONFIGURATION ---
SOURCE_HOST="box5665.bluehost.com"
SOURCE_USER="janaka@invelsrilanka.com"

DEST_HOST="imap.mail.us-east-1.awsapps.com"
DEST_USER="janaka@invelsrilanka.com"

# Log file with specific timestamp (e.g., migration_2026-01-20_15-30.log)
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")
LOG_FILE="migration_${TIMESTAMP}.log"

# Temporary password files (hidden)
PASSFILE1=".pwd_source_$$"
PASSFILE2=".pwd_dest_$$"

# --- CHECK PREREQUISITES ---
if ! command -v imapsync &> /dev/null; then
    echo "❌ Error: 'imapsync' is not installed."
    echo "   Install it with: sudo apt install imapsync (Ubuntu/Debian)"
    echo "   Or: sudo yum install imapsync (CentOS/RHEL)"
    exit 1
fi

# --- SAFETY CLEANUP TRAP ---
# This ensures password files are DELETED even if you press Ctrl+C or the script crashes.
cleanup() {
    rm -f "$PASSFILE1" "$PASSFILE2"
    echo ""
    echo "🔒 Security: Temporary password files deleted."
}
trap cleanup EXIT

# --- INPUT CREDENTIALS ---
clear
echo "======================================================="
echo "   📧 EMAIL MIGRATION: BLUEHOST -> AWS WORKMAIL"
echo "======================================================="
echo "SOURCE:      $SOURCE_USER ($SOURCE_HOST)"
echo "DESTINATION: $DEST_USER ($DEST_HOST)"
echo "LOG FILE:    $LOG_FILE"
echo "-------------------------------------------------------"

echo -n "🔑 Enter Source Password (Bluehost): "
read -s SRC_PASS
echo ""
echo -n "🔑 Enter Dest Password (AWS WorkMail): "
read -s DST_PASS
echo ""
echo "-------------------------------------------------------"

# Write passwords to temp files securely
echo "$SRC_PASS" > "$PASSFILE1"
echo "$DST_PASS" > "$PASSFILE2"

# --- EXECUTE MIGRATION ---
echo "🚀 Starting migration process..."
echo "   - Mode: COPY ONLY (No deletion)"
echo "   - Age Limit: 1825 days (5 years)"
echo "   - Folders: Full recursive copy + Subscription"
echo "   - Logging to: $LOG_FILE"
echo ""

# THE COMMAND
# --subdirs: Ensures nested folders (like Inbox/Project/Bill) are found
# --subscribe: Ensures AWS 'sees' the new folders immediately
# --automap: Fixes 'Sent' vs 'Sent Items' mapping automatically
# --maxage 1825: 5 Years limit
imapsync \
  --host1 "$SOURCE_HOST" --user1 "$SOURCE_USER" --passfile1 "$PASSFILE1" --ssl1 \
  --host2 "$DEST_HOST" --user2 "$DEST_USER" --passfile2 "$PASSFILE2" --ssl2 \
  --authmech2 LOGIN \
  --automap \
  --subscribe \
  --subdirs \
  --syncinternaldates \
  --maxage 1825 \
  --logfile "$LOG_FILE"

# --- COMPLETION CHECK ---
EXIT_CODE=$?

echo ""
echo "======================================================="
if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ SUCCESS: Migration completed without critical errors."
else
    echo "⚠️  FINISHED WITH ALERTS: Exit code $EXIT_CODE"
    echo "   (This is common if some individual emails were corrupt/skipped)"
fi
echo "======================================================="

# Show the summary from the log file (last 15 lines)
echo "📄 LOG SUMMARY:"
tail -n 15 "$LOG_FILE"
