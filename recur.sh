#!/bin/bash

echo -n '-what types of files should I search? (ex: .html) '
read filetype

for X in $(find . -name '*'$filetype'' -print)
do
	if [ -d $X ]
	then
		echo '**** "' $X '" is a directory'	
	else
		echo '**' $X
	fi
done
