#!/bin/bash
# check that three paramters were passed
if [ ! $# -eq 3 ] ; then
	echo "Error: parameters problem"
	exit 1
# check that both the directory and file exists
elif [ ! -d "$1" ] ; then
	echo "Error: DB does not exist"
	exit 1
elif [ ! -f "$1/$2" ] ; then
	echo "Error: table does not exist"
	exit 1
else
	# assign to a variable the number of commas in the 3rd argument
	argcount=$(echo "$3" | grep -o "," | wc -w)
	# assign to a variable the number of commas in the file being added to
	fileargcount=$(head -n 1 "$1/$2" | grep -o "," | wc -l)
	# if variables don't equal
	if [ "$argcount" -ne "$fileargcount" ] ; then
		echo "Error: number of columns in tuple does not match schema"
		exit 1
	else
		# append
		echo "$3" >> "$1/$2"
		echo "OK: tuple inserted"
		exit 0
	fi
fi
