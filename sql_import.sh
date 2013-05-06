#!/bin/bash
# script to import multiple dumps in the same folder
# takes in db_name, username and password to auto import the files

db=$1
user=$2
pw=$3
if [ "$db" = "" ]; then
echo "Usage: $0 db_name username password"
exit 1
fi

mkdir done
clear
for sql_file in *.sql; do
echo "Importing $sql_file";
mysql -u $user -p$pw $db< $sql_file;
mv $sql_file done;
done
