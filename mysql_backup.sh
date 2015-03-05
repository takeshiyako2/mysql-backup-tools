#!/bin/sh
today=`date +%Y%m%d`
oldday=`date --d "14day ago" +%Y%m%d`
target_dir="/home/XXXXXXXXXXXXX/MySQL_backup"
db_dump="/usr/bin/mysqldump"
mysql="/usr/bin/mysql"
user="root"
host="localhost"
mysql_password="XXXXXXXXXXXXX"

function mk_dir(){
    if [ ! -e $target_dir/$today ]
    then
        mkdir -p $target_dir/$today/
    fi
}

function db_backup(){
    database_list=`$mysql -u$user -p$mysql_password -h$host -e "show databases"|grep -v Database|egrep -vi 'information_schema|performance_schema'`
    for i in $database_list
    do
        echo "db backup $i"
        $db_dump -u$user -p$mysql_password -h$host --single-transaction --master-data=2 $i | gzip > $target_dir/$today/${i}.gz
    done
}

function rm_dir(){
    if [ -e $target_dir/$oldday ]
    then
        rm -fr $target_dir/$oldday
    fi
}

mk_dir
db_backup
rm_dir


#


