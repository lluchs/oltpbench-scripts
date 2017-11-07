#!/bin/bash

set -eu
cd "$( dirname "${BASH_SOURCE[0]}" )"
scriptdir=`pwd`

export LC_ALL=C

. mysql-cfg.sh

rm -r /tmp/oltpbench
mkdir /tmp/oltpbench
$mysqlsrc/sql/mysqld  --defaults-file="$mysqlcfg" --initialize-insecure
killall mysqld || true
#sudo chown -R mysql:mysql /tmp/oltpbench
sleep 5
./mysql-run.sh &
sleep 5
echo "create database tpcc" | $mysqlsrc/client/mysql -u root -S /tmp/oltpbench.sock
$mysqlsrc/client/mysql -S /tmp/oltpbench.sock -u root <<< "CREATE USER 'root'@'%' IDENTIFIED BY '';"
$mysqlsrc/client/mysql -S /tmp/oltpbench.sock -u root <<< "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%';"

kill %1
