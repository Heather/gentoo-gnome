#!/bin/bash

# Wrapper script for find-keywordreq.py.
# Builds a temporary overlay and check for dependencies with repoman

cd $(dirname $0)

#PORTDIR=$(portageq portdir)
PORTDIR=/home/eva/devel/gentoo-x86

rm -rf /tmp/tmptree
rm -rf /tmp/step1.list

python find-keywordreq.py $@ > /tmp/step1.list

while read line
do
	ATOM=$(echo $line | cut -f1 -d: | sed -nr 's/(.*)-[0-9.]+.*/\1/p'| xargs echo)
	PN=$(echo $ATOM | cut -f2 -d/ | xargs echo)
	VERSION=$(echo $line | cut -f1 -d: | sed -nr 's/.*-([0-9.]+.*)/\1/p' |xargs echo)
	KEYWORDS=$(echo $line | cut -f2 -d:)
	mkdir -p /tmp/tmptree/$ATOM
	cp $PORTDIR/$ATOM/$PN-$VERSION.ebuild \
		/tmp/tmptree/$ATOM
	for keyword in $(echo $KEYWORDS)
	do
		ekeyword ~$keyword /tmp/tmptree/$ATOM/$PN-$VERSION.ebuild > /dev/null
	done
done < /tmp/step1.list

cd /tmp/tmptree
PORTDIR="${PORTDIR}" PORTDIR_OVERLAY="/tmp/tmptree" repoman manifest
PORTDIR="${PORTDIR}" PORTDIR_OVERLAY="/tmp/tmptree" repoman full
