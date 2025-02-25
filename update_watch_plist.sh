#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

PLIST_FILE="$SCRIPT_DIR/pl.maciejgad.qrCode.watch.plist"
sed -i '' "s|/Users/bazyl/Code/QRCodeGenerator/|$SCRIPT_DIR/|g" "$PLIST_FILE"