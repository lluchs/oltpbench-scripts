#!/bin/bash

set -eu
cd "$( dirname "${BASH_SOURCE[0]}" )"

# Restore database from archive.
if [[ -f oltpbench-db.tar ]]; then
	rm -rf /tmp/oltpbench
	tar -C/tmp -xf oltpbench-db.tar
else
	echo No snapshot
	exit 1
fi

