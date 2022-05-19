#!/bin/bash
# check if arguments passed is not equal to 3
if [ ! $# -eq 3 ] ; then
	echo "Error: parameters problem"
	exit 1
# check if both the directory given as the first argument and file given as second exist
elif [ ! -d "$1" ] ; then
	echo "Error: DB does not exist"
	exit 1
elif [ -f "$1/$2" ] ; then
	echo "Error: table already exists"
	exit 1
else
	# could have omitted the touch and just used the echo statement but doing it explicitly
	touch "$1/$2"
	echo "$3" > "$1/$2"
	echo "OK: table created"
	exit 0
fi
