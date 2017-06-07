#!/bin/bash

dir=$1

if [ ! `which html2haml 2>/dev/null` ]
then
	echo "Error:"
	echo "No html2haml program installed"
	echo "Please install html2haml"
	echo "You probably want to do \$ gem install html2haml"
	exit 1
fi

if [ ! $dir ]
then
	echo "Error:"
	echo "You must provide a path"
	echo "Example:"
	echo "$0 apps/views/foo"
	exit 1
fi

if [ ! -d $dir ]
then
	echo "Error:"
	echo "$dir does not appear to be a directory"e
	exit 1
fi

for file in `find $dir -name '*.erb' -type f`
do
	echo "Changing $file -> ${file%erb}haml"
	html2haml -e $file ${file%erb}haml && rm $file
done
