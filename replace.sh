#!/bin/bash
# simple script to scan directory finding and replacing one pair of strings into 
# a new file stored in a specified alreay existing directory

echo -n '**This script will search over a directory to find and replace the given strings'
echo
echo -n 'what am i finding? '
read valueA
echo -n 'what is replacing it? '
read valueB
echo -n 'what types of files should I search? (ex: .html) '
read filetype
echo -n 'what directory should I save modified files to? '
read dir

if [ -d "$dir" ]  # test to see if input dir exists
then
	echo $dir ' exists'
else
	mkdir $dir
fi

for X in *$filetype
do
	echo $X
	sed 's:'$valueA':'$valueB':g' <$X >$dir/$X
done