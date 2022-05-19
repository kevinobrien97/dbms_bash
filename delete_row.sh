#!/bin/bash
if [ $# -gt 3 ] || [ $# -lt 2 ] ; then
        echo "Error: parameters problem"
        exit 1
elif [ ! -d "$1" ] ; then
        echo "Error: DB does not exist"
        exit 1
elif [ ! -f "$1/$2" ] ; then
        echo "Error: table does not exist"
        exit 1
else
	# count number of rows in table (will always be at least one - headers)
	rowcount=$(wc -l <"$1/$2")
	string="$3"
	# loop through rows in the 3rd argument
	for var in ${string//,/ } ; do
		# if its the header
		if [ "$var" -eq 1 ]; then
			echo "Error: you cannot delete the table header"
			exit 1
		fi
		# if any number not in range of 1 to number of rows
		if [ "$var" -gt "$rowcount" ] || [ "$var" -lt 1 ] ; then
			echo "Error: row $var does not exist. There are $rowcount rows in the table."
			exit 1
		fi
	done
	# delete rows
	sed -i "$3"d "$1/$2"
	echo "OK: row(s) deleted"
	exit 0

fi
