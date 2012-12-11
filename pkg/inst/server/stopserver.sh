#!/usr/bin/env bash

path=$1
SERVERPID=$path/healthvisServer/.serverpid

if [ -f $SERVERPID ]; then
	PID=$(cat $SERVERPID)
	PROCESS=$(ps -p $PID | grep python)
	if [ "$PROCESS" != "" ]; then
		echo "Killing healthvisDevel server"
		kill $PID
	else
		echo "Stale PID, deleting"
	fi
	rm $SERVERPID
else
	echo "healthvisDevel pid file not found"
fi
