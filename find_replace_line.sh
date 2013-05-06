#!/bin/bash
# **script will scan over directory & subdirectories with a file formatted 
# **"find_str \n replace_str \n\n find_str \n replace_str" and find/replace those strings

# **does not support removing of files currently

read_in_line(){

input=$1
tobemoved=$2
toberemoved=$3

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
		if [ $tobemoved == "Y" ]
		then
			# does not work if directory is not already created
			mv "$search" "$replace"
		#elif [ $toberemoved == "Y" ]
		#then
		#	rm "$search"
		fi
		search=""
		replace=""
	fi
done < $input
}

find_replace(){

filetype=$1
for X in $(find . -name '*'$filetype'' -print)
do
	if [ -d $X ]
	then
		echo '**** "' $X '" dir skipped' >> log # obsolete line
	else
		echo '**' $X >> log
		sed -f .sedscript_temp <$X >$X'_'
		rm $X
		mv $X'_' $X
	fi
done
}

echo '  ** This script will search over current directory' 
echo '  ** & subdirectories to find and replace'
echo '  ** the given strings.  Input file should be formated:'
echo '  **   "find_str \n replace_str \n \n find_str \n replace_str". '
echo '  ** Supports phrases with spaces in renaming, but not moving.'
echo '  ** Directories must already exist to move files into.'
echo
echo -n '-what file should I read find/replace from? '
read input
echo -n '-does this file contain links of files to be moved accordingly? Y/N '
read tobemoved
echo -n '-what types of files should I search through? (ex: .html) '
read filetype

read_in_line $input $tobemoved
find_replace $filetype

rm .sedscript_temp