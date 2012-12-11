#!/usr/bin/env bash

path=$1
port=$2
SERVERPID=$path/healthvisServer/.serverpid

$path/healthvisServer/bin/python $path/healthvisServer/runit.py $port >/dev/null 2>/dev/null &
echo $! > $SERVERPID

