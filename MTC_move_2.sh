#!/bin/bash
# Aug 26, 2011
# script written to help with the move of many html files to new locations and 
# update all links associated to them on all specified files in the home directory
# add_root() and line_rename() are functions copied from named scripts
# variables are mostly key to this particular project, but can easily be changed or manipulated


add_root(){

input=$1
add=$2

if [ ! -f $input ]
then
	echo "ERROR: file does not exist"
	kill 0
fi

while read linevar
do	
	if [ ! -d "$linevar" ]
	then 
		echo "$linevar" | cat >>$input'_format'
		echo "$add$linevar" | cat >>$input'_format'
		echo "" | cat >>$input'_format'
	else
		echo "*** $linevar is directory" >> log
	fi
done < $input
}


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





#if [ -d ~/Desktop/MTC_new ]
#then
#	cd ~/Desktop/MTC_new
#else
#	echo " ERROR: no directory named MTC_new"
#	kill 0
#fi



echo "------------------- Begin Log File -------------------" >log

echo "**** Does not work with brackets [ ] in file names/addresses"
#echo "~~Creating directories as listed in make_dir.sh"
#make_dir.sh

Y="Y"
N="N"
html=".html"
js=".js"

echo "~~Running line_rename.sh for files TO BE moved"
#echo -n "  ~~name first file "
#read first_file
first_file="../link_updates"
echo "------------------- read_in_line for $first_file -------------------" >> log
read_in_line $first_file $N $N
echo "------------------- find_replace .html for $first_file -------------------" >> log
find_replace $html
#echo "------------------- find_replace .js for $first_file -------------------" >> log
#find_replace $js

echo "~~Running line_rename.sh for files NOT to be moved"
#echo -n "  ~~name second file "
#read scnd_file
scnd_file="../remove_links"
echo "------------------- read_in_line for $scnd_file -------------------" >> log
read_in_line $scnd_file $N $N
echo "------------------- find_replace .html for $scnd_file -------------------" >> log
find_replace $html
#echo "------------------- find_replace .js for $scnd_file -------------------" >> log
#find_replace $js

#echo "~~Moving & Removing files as listed in move_remove.sh"
#move_remove.sh


echo "~~Running line_rename.sh for directory adjustment"
direc_adj="../directory_format"
echo "------------------- read_in_line for $direc_adj -------------------" >> log
read_in_line $direc_adj $N $N
echo "------------------- find_replace .html for $direc_adj -------------------" >> log
find_replace $html
echo "------------------- find_replace .js for $direc_adj -------------------" >> log
#find_replace $js

rm .sedscript_temp
mv log ../log

