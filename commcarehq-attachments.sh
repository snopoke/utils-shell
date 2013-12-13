#!/bin/bash
# Usage: 
#	./commcarehq-attachments.sh [username] [urls]
#
#	username 	- Username on CommCareHQ that has access to the project space.
#	urls 		- file containing the attachment URL's. One URL per line. 
#
# Example URL:
#	https://www.commcarehq.org/a/{project-space}/reports/form_data/{form-guid}/download-attachment/?attachment={attachment-name}
#
###################################

download() {
	attachment=`echo $2 | cut -d / -f10 | cut -d = -f2`
	echo "Downloading $attachment"
	curl -s --digest -u $3 -o "$1/$attachment" $2
}
export -f download

FOLDER="attachments"
mkdir -p $FOLDER

filename="$2"

read -s -p "Enter Password: " password

echo

while read -r line
do
	sem --gnu -j10 download $FOLDER $line "$1:$password"
done < $filename

sem --gnu --wait
echo "done"
