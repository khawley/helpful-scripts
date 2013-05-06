#!/bin/bash
# **script will scan over directory with a file formatted 
# **"find_str replace_str \n find_str replace_str" and find/replace those strings

echo '**This script will search over a directory to find and replace the given strings'
echo '**Saves modified files into a given directory'
echo '**Input file should be formated "find_str replace_str \n find_str replace_str" '
echo '** Does not support phrases with spaces'
echo
echo -n '-what file should I read find/replace from? '
read input
echo -n '-what types of files should I search? (ex: .html) '
read filetype
echo -n '-what directory should I save modified files to? '
read dir

if [ -d "$dir" ]  # test to see if input dir exists
then
	echo 
else
	echo "making " $dir
	mkdir $dir
fi

if [ ! -f $input ]
then
	echo "ERROR: file does not exist"
	kill 0
fi

echo >.sedscript_temp # creates empty temp file
search=""
replace=""

while read linevar
do
	if [ "$search" == "" ]   # test to see if search has 0 length
	then
		search=$linevar
	elif [ "$replace" == "" ]
	then
		replace=$linevar
	fi
	
	if [ "$replace" != "" ] 
	then
		echo '*search:' $search 'replace:' $replace >> log
		echo 's:'$search':'$replace':g' >>.sedscript_temp # appends sed command to file	
		search=""
		replace=""
	fi
done < $input

for X in *$filetype
do
	if [ -d $X ]
	then
		echo '**** "' $X '" dir skipped'
	else
		echo '**' $X
		sed -f .sedscript_temp <$X >$dir/$X
	fi
done

rm .sedscript_temp