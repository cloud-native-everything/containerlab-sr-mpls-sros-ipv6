#/bin/sh

set -euo pipefail

DEV=e1
ID=102
LINK_ADDR="10.10.20.${ID}"

apk update
apk add tcpdump
ip address add "$LINK_ADDR"/24 dev "${DEV}"
