#!/bin/bash

# *** Configuration *** #

# Path to the folder we want to monitor
WATCH_FOLDER="CreateQR/"

# Path to the script that should run after detecting a change
SCRIPT_TO_RUN="qr_from_webloc.sh"

# *** End *** #

FSWATCH=/opt/homebrew/bin/fswatch
PLIST_BUDDY=/usr/libexec/PlistBuddy

echo "Starting watch.sh"
date

# Get the folder of the script
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
echo "Script directory: $SCRIPT_DIR"
echo "Watching $SCRIPT_DIR/$WATCH_FOLDER"
# Checking if fswatch is installed
if ! command -v $FSWATCH >/dev/null 2>&1; then
    echo "fswatch is not installed."
    echo "To install it, run the following command:"
    echo "brew install fswatch"
    exit 1
fi

# Monitoring the folder using fswatch
$FSWATCH -0 "$SCRIPT_DIR/$WATCH_FOLDER" | while read -d "" event
do
    
    if [[ "$event" == *".DS_Store" ]]; then
        continue
    fi
    if [[ ! -f "$event" || "${event##*.}" != "webloc" ]]; then
        continue
    fi
    echo "New file: $event"
    sh "$SCRIPT_DIR/$SCRIPT_TO_RUN" "$event"
done