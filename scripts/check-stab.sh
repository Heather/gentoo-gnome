#!/bin/bash

# Author: Gilles Dartiguelongue <eva@gentoo.org>
# Reference: Email sent 11 Aug 2009
# Content:
#
# Ok guys,
#
# it looks like I never sent this to everyone, maybe just pasted a link on
# irc. This is the script I used in the last releases to write nice
# reports for arch teams to know what they had to do. It's of course full
# of bugs, dog ass slow and whatever you want it to be besides efficient.
#
# I always dream of rewriting this shit using portage's python API but
# since I can't figure how to dig into it, it still hasn't happened.
#
# This script can either run on packages you have installed or in a list
# of atoms you pass as argument. It writes a bump.list to /tmp that you
# can then attach to a bug report.

#CVS_PORTDIR=$(portageq portdir)
CVS_PORTDIR="<SET THIS BEFORE USING>"

cd "${CVS_PORTDIR}"

EXPERIMENTAL="s/~\?mips\|~\?sparc-fbsd\|~\?x86-fbsd//g"

if [ -z $1 ]; then
	PACKAGES=$(eix -I --only-names)
else
	PACKAGES=$@
fi

echo ">>> Check dependencies with repoman ? [y/N]"
read repocheck
#repocheck="n"

rm /tmp/bump.list
touch /tmp/bump.list

# Get the complete official arch list
ARCH_LIST=$(cat /usr/portage/profiles/arch.list |xargs echo)

for x in ${PACKAGES}
do
	echo "Reading $x ChangeLog"
	CAT=$x

	LOG=$(sed -n "1,/^\\*/p" ${CAT}/ChangeLog)

	LAST_BUMP=$(echo ${LOG} | tail -n1 |\
		sed -e "s/.* (\([0-9]\{1,2\} [a-zA-Z]\{3\} [0-9]\{4\}\))/\1/")

	TS_BUMP=$(LC_ALL="C" date --date="${LAST_BUMP}" +%s)
	TS_NOW=$(LC_ALL="C" date --date="30 days ago" +%s)

	EBUILD=$(sed -n "/^\\*/,+1p" ${CAT}/ChangeLog|\
		sed "s/^\\*//g;s/ (.*/.ebuild/g"|head -n1)
	VERSION=$(sed -n "/^\\*/,+1p" ${CAT}/ChangeLog|\
		sed "s/^\\*//g;s/ (.*//g;s/.*\?-\([0-9]\)/\1/g"|head -n1)

	KEYWORDS=$(sed -n "/KEYWORDS/,1p" ${CAT}/${EBUILD} |\
		sed -e "${EXPERIMENTAL}"|\
		sed "s/KEYWORDS=\"//g;s/\"//g;s/$/\n/g")

	HERD=$(sed -n "/<herd>/,1p" ${CAT}/metadata.xml |\
		sed "s:</\?herd>::g"|xargs echo)

	echo "$VERSION: ${KEYWORDS}"

#	if [ ${TS_BUMP} -le ${TS_NOW} ] &&
	if [ -n "$(echo ${KEYWORDS}|grep "~")" ]; then
#	   [ -n "$(echo ${HERD} |egrep "gnome(-.*)?|freedesktop|gstreamer")" ]; then

	   	arch_stab=""
		printf '%-45s: ' ${CAT}-${VERSION} >> /tmp/bump.list

		for keyword in ${ARCH_LIST}; do
			# don't take fbsd into account
			k1=$(echo $keyword |sed "s/-fbsd//g")
			k2=$(echo $keyword |sed "s/~//g")
			SIZE=$(echo $keyword |wc -m)

			if [ "$keyword" != "$k1" ]; then
				continue
			fi

			success=0
			for k in ${KEYWORDS}
			do
				if [ "~${keyword}" = "$k" ]; then
					success=1
					break
				fi
			done

			if [ $success -eq 0 ]; then
				printf "%${SIZE}s" "$(echo $keyword | sed "s/./ /g")"  >> /tmp/bump.list
				continue
			fi

			if [ "$k" != "${k2}" ]; then
				printf "%${SIZE}s" "$keyword" >> /tmp/bump.list
				arch_stab="${arch_stab} ${keyword}"
			else
				printf "%${SIZE}s" "$(echo $keyword | sed "s/./ /g")"  >> /tmp/bump.list
			fi
		done
		
		echo -e "" >> /tmp/bump.list

		# Create an overlay for later examination
		case $repocheck in
			"y"|"Y")
				pushd $(pwd) &> /dev/null
				mkdir -p /tmp/portage/${CAT}
				cp -r ${CAT}/* /tmp/portage/${CAT}
				rm /tmp/portage/${CAT}/*.ebuild
				cp ${CAT}/${EBUILD} /tmp/portage/${CAT}/
				cd /tmp/portage/${CAT}

				ekeyword $(echo $arch_stab | tr -s \ ) ${EBUILD}

				ebuild ${EBUILD} manifest

				popd &> /dev/null
				;;
			*)
				;;
		esac

	fi
done

case $repocheck in
	"y"|"Y")

		for x in $(ls /tmp/portage/*/*/*.ebuild)
		do
			pushd $(pwd) &> /dev/null

			cd $(dirname $x)
			ACCEPT_KEYWORDS="amd64" PORTDIR_OVERLAY="${CVS_PORTDIR} /tmp/portage" repoman --without-mask full

			popd &> /dev/null
		done
		;;
	*)
		;;
esac

