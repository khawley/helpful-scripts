#!/bin/bash

echo -n '-what file should I format for line_rename.sh? '
read input
echo -n '-what text should I add to the beginning of the link? '
read add
#add= "/"

while read linevar
do
	if [ ! -d "$linevar" ]
	then 
		echo "$linevar" | cat >>$input'_format'
		echo "$add$linevar" | cat >>$input'_format'
		echo "" | cat >>$input'_format'
	else
		echo "*** $linevar is directory"
	fi
done < $input