#!/bin/bash

set -eu
cd "$( dirname "${BASH_SOURCE[0]}" )"

. mysql-cfg.sh

exec $mysqlsrc/sql/mysqld --defaults-file="$mysqlcfg"
