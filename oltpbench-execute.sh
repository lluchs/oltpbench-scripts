#!/bin/sh

set -eu
cd "$( dirname "${BASH_SOURCE[0]}" )"
scriptdir=`pwd`

export LC_ALL=C

cd ../oltpbench
./oltpbenchmark -b tpcc -c "$scriptdir/sample_tpcc_config.xml" --execute=true

