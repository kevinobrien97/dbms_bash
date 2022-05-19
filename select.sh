#!/bin/bash
# check if anything but 2 or 3 args
if [ $# -gt 3 ] || [ $# -lt 2 ] ; then
	echo "Error: parameters problem"
	exit 1
# check types
elif [ ! -d "$1" ] ; then
	echo "Error: DB does not exist"
	exit 1
elif [ ! -f "$1/$2" ] ; then
	echo "Error: table does not exist"
	exit 1
elif [ $# -eq 2 ] ; then
	echo "start_result"
	# print entirety of file
	echo "$(<"$1/$2")"
	echo "end_result"
	exit 0
else
	filecount=$(head -n 1 "$1/$2" | grep -o "," | wc -l)
	filecount=$((filecount+1))
	string="$3"

	for var in ${string//,/ } ; do
		if [ "$var" -gt $filecount ] || [ "$var" -lt 1 ] ; then
			echo "Error: column does not exist"
			exit 1
		fi
	done
	# below is an attempt I made at printing the columns in the order they appear - see m write up for more detail
	# assign emppty string
#	dollarstring=""
#	for var in ${string//,/ } ; do
		# loop through elements and add a dollar sign and comma
#		dollarstring+="$"
#		dollarstring+="$var,"
#       done
	# remove the comma
#	dollarstring2=${dollarstring::-1}
	# below method words if columns are specified in the same way as the resulting dollarstring variable
#	awk -v dollarstring2=$dollarstring2 'BEGIN {FS=OFS=","} {print $dollarstring2}' "$1/$2"

	echo "start_result"
	cut -d, -f "$3" "$1/$2"
	echo "end_result"
fi

