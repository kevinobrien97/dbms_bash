#!/bin/bash
# check if number of args is less than one and greater than one 
if [ $# -lt 1 ] ; then
	echo "Error: no parameter"
	exit 1
elif [ $# -gt 1 ] ; then
	echo "Error: too many parameters"
	exit 1
# check if DB already exists
elif [ -d "$1" ] ; then
	echo "Error: DB already exists"
	exit 1
else
	# execute instruction to make directory (i.e. database) and exit successfully
	mkdir "$1"
	echo "OK: database created"
	exit 0
fi
