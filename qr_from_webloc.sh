#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <path_to_webloc>"
    exit 1
fi

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PLIST_BUDDY=/usr/libexec/PlistBuddy
SCRIPT_TO_RUN="qr.sh"
FILE=$(printf %q "$1")

echo "File: $FILE"
pwd

url=$($PLIST_BUDDY -c "Print :URL" "$FILE" 2>/dev/null)
echo "URL: $url"
sh "$SCRIPT_DIR/$SCRIPT_TO_RUN" $url 
rm "$FILE"