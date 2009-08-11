#!/bin/sh

# Find specific python bindings import and prints a list of split python package
# corresponding to those import.

if [ $# -ne 1 ]; then
	echo "usage: $0 PATH"
	exit 1
fi

TMP=$(mktemp)

BASE=$(dirname $0)
$BASE/find-split-python.sh > $TMP

IMPORT_LINES=$(find $1 -name "*.py" -exec egrep "^[[:blank:]]*import " {} \; |\
		sed "s/;.*//g" |\
		sed "s/from \(.*\+\) import .*/import \1/g" |\
		sed "s/import \(.*\+\) as .*/import \1/g" |\
		sed "s/^.*import //g" |\
		sed "s/^\(.*?\)\./\1/g" |\
		sort |uniq)
for import_line in $IMPORT_LINES
do
	IMPORTS="${IMPORTS} $(echo $import_line |sed "s/,/\n/g"|cut -f1 -d.)"
done

IMPORTS=$(echo $IMPORTS|sed "s/ /\n/g"|sort|uniq)

echo $IMPORTS

# Find the python files
for import in $(echo $IMPORTS)
do
	if egrep -iq " $import($|,|[[:blank:]])" $TMP; then
		#echo ""
		echo -n " * Mapping $import"
		echo ": $(egrep -i " $import( |,|$)" $TMP | cut -f1 -d:|xargs echo)"
	#else
		#echo -n "$import, "
	#	echo ""
	fi
done

echo ""
rm $TMP
