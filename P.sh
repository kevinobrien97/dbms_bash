
#!/bin/bash
#if [ $# -lt 1 ] ; then
#	touch "$1"
#	while ! ln "$0" "$1-lock" 2>/dev/null;
#	do sleep 1
#	done
#	rm "$1"
#	exit 0
#else
#echo "$1"
if [ ! -z "$1" ] ; then
	while ! ln "$0" "$1-lock" 2>/dev/null; do
	sleep 1
	echo "dollar 1: $1 "
	done

fi
exit 0
