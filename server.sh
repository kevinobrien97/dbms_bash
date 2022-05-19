#!/bin/bash
# if server.pipe does not exist then create it (prevents two instances being open)
if [ ! -p server.pipe ] ; then
        mkfifo server.pipe
else
        echo "Error: server pipe already running"
        exit 1
fi
# enter continuous loop
while true; do
# read the input from the server.pipe as an array
read -r -a input < server.pipe
# client will have send the ID as the last element so assign this to ID variable
id="${input[-1]}"
# once assigned delete the ID from the array
unset 'input[-1]'
# command will be first in the array
case ${input[0]} in
	# each case to match key word
	create_database)
		# create a lock on the database (i.e. element 1 in array if it exists)
		./P.sh "${input[1]}"
		# run the script using everything except the first element (i.e. the command) and send to pipt in background
		./create_database.sh "${input[@]:1}" > "$id.pipe" &
		# unlock script
		./V.sh "${input[1]}"
		;;
	create_table)
		./P.sh "${input[1]}"
		./create_table.sh "${input[@]:1}" > "$id.pipe" &
		./V.sh "${input[1]}"
		;;
	insert)
		./P.sh "${input[1]}" &
		./insert.sh "${input[@]:1}" > "$id.pipe" &
		./V.sh "${input[1]}"
		;;

	select)
		./P.sh "${input[1]}"
		./select.sh "${input[@]:1}" > "$id.pipe" &
		./V.sh "${input[1]}"
		;;
	# extra feature
	delete_row)
		./P.sh "${input[1]}"
		./delete_row.sh "${input[@]:1}" > "$id.pipe" &
		./V.sh "${input[1]}"
		;;
	# if client sends shutdown command
	shutdown)
		# send exit code through pipe
		echo "exit 0" > "$id.pipe"
		# delete pipe and quit
		rm "server.pipe"
		exit 0
		;;
	# if client sends exit command (NOT if user of client sends exit command)
	exit)
		# delete pipe and exit
                rm "server.pipe"
                exit 0
                ;;

	*)
		# a bad request triggers exit command to be sent to client pipe as well as quitting server
		# everything quits if bad request - assuming this is the approach required but could have programmed otherwise
		echo "Error: bad request" > "$id.pipe"
		echo "exit 1" > "$id.pipe"
		rm "server.pipe"
		exit 1
esac
done
