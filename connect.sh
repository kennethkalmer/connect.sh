#!/bin/bash
#
# Custom SSH connection manager for me :P
#

# get our list of hosts
CONF=~/.connect

# Setup our array for sotring connections
HOSTS=
HOST_INDEX=1

# Loop index
i=1

# loop and present
while [ $i -le `wc -l $CONF | gawk '{print $1}'` ]; do
	
	# get the line from the file
	line=`head -$i $CONF | tail -1`

	# Group declaration?
	if [[ ${line:0:2} == "--" ]]; then
		# output
		echo
		echo ${line:3}

	# No, track the host in our list
	else
		# split into host and descriptions
		h=`echo $line | cut -d , -f 1`
		d=`echo $line | cut -d , -f 2`

		# add to our list
		HOSTS[$HOST_INDEX]="$h"

		# out the option
		echo " ($HOST_INDEX) $h - $d"

		# up the host counter
		HOST_INDEX=`expr $HOST_INDEX + 1`
	fi

	# Up the counter
	i=`expr $i + 1`
done

# Prompt if we dont have a number
if [ -z $1 ]; then
	# Now prompt
	echo
	echo -n "Enter host number: "

	# Now get the host
	read run
	SELECTION=${HOSTS[$run]}

	# edit the file if 0
	if [[ 0 -eq $run ]]; then
	        vi ~/.connect/hosts
       		exit 0
	fi
else
	SELECTION=${HOSTS[$1]}
fi

# Die if nothing
if [ -z "$SELECTION" ]; then 
	exit 1
fi

# split address and port
host=`echo $SELECTION | cut -d : -f 1`
port=`echo $SELECTION | cut -d : -f 2`

# if the port isn't specified, take 22
if [ "$port" == "$host" ]; then
	port=22
fi

# connect
clear
echo "Connecting to $host on port $port..."
ssh -p $port $host
