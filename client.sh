#!/bin/bash
trap ctrl_c INT
# define functions at outset
function ctrl_c() {
	# send word exit to server
	echo "exit $id" > server.pipe
	rm "$id.pipe"
	exit 0
}

function server_quit() {
	rm "$id.pipe"
	# $1 prints the exit command, i.e. exit 0 or exit 1
	$1
}

if [ $# -eq 1 ] ; then
	# make the client pipe
	id="$1"
	if [ ! -p "$id.pipe" ] ; then
                mkfifo "$id.pipe"
        else
        	echo  "Error: client with this ID is already active"
        	exit 1
        fi
	while true; do
		# read input from terminal
		read input
		# check server.pipe exists
		if [ ! -p server.pipe ] ; then
                        rm "$id.pipe"
                        echo "Error: server is not running"
                        exit 0
                fi
		# exit clause for users that they need to confirm their choice
		if [[ $input = 'exit' ]]; then
			# await answer
			read -r -p "Are you sure you want to exit? (y/n)> " answer
				# regex
				if [[ "$answer" =~ ^([yY][eE][sS]|[yY])$ ]] ; then
				# send exit to server
				echo "$input $id" > server.pipe
				rm "$id.pipe"
				exit 0
			fi
		else
		# send input to server plus ID
		echo "$input $id" > server.pipe
		while read output; do
			# invoke function if output includes exit
			if [[ $output == *"exit"* ]]; then
				server_quit "$output"
			# for most scripts except select
			elif [[ $output == *"OK:"* || $output == *"Error"* ]]; then
				echo "Command successfully executed"
				echo "$output"
				break
			# for select
			else
				echo "$output"
				if [[ $output == *"end_result"* ]]; then
					break
				fi
			fi
			done < "$id.pipe"

fi
done
else
	echo "Error: specify your client ID only to run the program" 2>&1
	exit 1
fi
