#!/bin/bash
echo "name of the script is $0"
echo
#fetching the file as input in args
input="$1"

#checking the file exist and it has contents

if [[ ! -e "$input" || ! -s "$input" ]];
then 
echo "Error the file does not exist or the file has no contents !!!"
echo "check the file" >&2
exit 
fi

#extraction of the params

cat "$input" | sed -n '/"frame.time":/p;/"wlan.fc.type":/p;/"wlan.fc.subtype":/p;/"wlan.fc.subtype":/a\ ' > output.txt

#checking for the matched params present or not

if [[ ! -s "output.txt" ]];
then
echo "no matching parameters found"
exit 
fi
echo "the expected parameters from the file is extracted and stored in output.txt"
echo 

#providing a option to view the output.txt

read -p 'to view the output file type "press enter" ' key
if [[ "$key" == "" ]];
then 
cat output.txt
fi

