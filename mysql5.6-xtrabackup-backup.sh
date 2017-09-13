#!/bin/bash
#base on mysql5.6.xx, you need to grant replication client, reload on your mysql server
LOGFILE=/var/log/mysql_backup.log
FSTAMP=`date +%F`
ISTAMP=`date +%F-%H-%M-%S`
#FBPATH="/nfs/media_share/backup/auto/database/fullbackup/dbstylewe"
FBPATH="/data/mysql/full"
#IBPATH="/nfs/media_share/backup/auto/database/incrementbackup/dbstylewe"
IBPATH="/data/mysql/increment"
STAND="innobackupex --user=backup --password=password --no-timestamp --no-lock"
LOCALFULL=/data/mysql/full
[ -d $LOCALFULL/`date -d "1 day ago" +%F` ] && rm -rf $LOCALFULL/`date -d "1 day ago" +%F`


if [ -d $FBPATH/$FSTAMP ];then
	echo
else
	echo " " >> $LOGFILE
	echo " " >> $LOGFILE
	echo " " >> $LOGFILE
	echo "========================Start full backup @ $FSTAMP========================" >> $LOGFILE
	$STAND $FBPATH/$FSTAMP &>> $LOGFILE
	echo "========================End full backup @ $FSTAMP========================" >> $LOGFILE
	#
	echo "========================The first increment backup today @ $ISTAMP========================" >> $LOGFILE
	$STAND --incremental $IBPATH/$ISTAMP --incremental-basedir=$FBPATH/$FSTAMP &>> $LOGFILE
fi
sleep 2
#increment
echo " " >> $LOGFILE
echo " " >> $LOGFILE
echo " " >> $LOGFILE
echo "========================Start increment backup @ $ISTAMP========================" >> $LOGFILE
LAST_DIR=`ls $IBPATH | sort -n | tail -1`
$STAND --incremental $IBPATH/`date +%F-%H-%M-%S` --incremental-basedir=$IBPATH/$LAST_DIR &>> $LOGFILE
echo "========================End increment backup @ $ISTAMP========================" >> $LOGFILE
