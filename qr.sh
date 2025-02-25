#!/bin/bash
if [ -z "$1" ]; then
    echo "Usage: $0 <link>"
    exit 1
fi

LINK=$1
TMPDIR=$(mktemp -d)
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

DOMAIN=$(echo $LINK | awk -F[/:] '{print $4}')
echo "Domain: $DOMAIN"

"$SCRIPT_DIR/bin/qrCodeGenerator" $LINK $TMPDIR/$DOMAIN.png
open  $TMPDIR/$DOMAIN.png