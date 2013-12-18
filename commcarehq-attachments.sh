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

TARGET="attachments"
mkdir -p $TARGET

username="$1"
input="$2"

read -s -p "Enter Password: " password

echo

download() {
	url=$1
	trimmed=`echo "$url" | sed -e 's/^ *//g' -e 's/ *$//g'`
	if [ -n "$trimmed" ]; then
		attachment=`echo $trimmed | cut -d / -f10 | cut -d = -f2`
		path="$TARGET/$attachment"
		if [ ! -f "$path" ]; then
			echo "Downloading $attachment"
			curl -s --digest -u $AUTH -o "$path" $url
		else
			echo -n '.'
		fi
	fi
}

export -f download
export TARGET=$TARGET
export AUTH="$username:$password"

xargs -P 20 -n 1 bash -c 'download "$@"' _ <$input