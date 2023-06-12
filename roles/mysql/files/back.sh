#!/bin/bash

day="$(date +'%A')"
db_backup="mydb_${day}.sql"
sudo /bin/mysqldump  -uroot -pHunter1981! --no-tablespaces --set-gtid-purged=OFF wordpress  >/home/backupdb/${db_backup}
