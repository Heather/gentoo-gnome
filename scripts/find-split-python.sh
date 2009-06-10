#!/bin/sh

# Build a package/python module mapping file
# This currently works for split python packages only

REPO=$(portageq portdir)
TMP=$(mktemp)

# Adding well known entries
echo "dev-python/pygtk: gtk
dev-python/pygobject: gio gobject" > $TMP

# Find ebuilds using the gnome-python eclass
for x in $(find $REPO/dev-python -name "*.ebuild" \
	-exec egrep -H "inherit.*gnome-python-common" {} \; |\
	cut -f1 -d:)
do
	CAT="$(echo ${x#$REPO/} |cut -f 1 -d /)"
	PN="$(echo ${x#$REPO/} |cut -f 2 -d /)"

	if egrep -q G_PY_BINDINGS $x; then
		BINDINGS=$(sed -n "/G_PY_BINDINGS/ p" $x | sed "s/G_PY_BINDINGS=\"//;s/\"//")
	else
		BINDINGS="${PN%-python}"
	fi

	# There might be multiple bindings per package
	BINDINGS_OUT=""
	for binding in $BINDINGS; do
		if python -c "import $binding" 2> /dev/null; then
			BINDINGS_OUT="$BINDINGS_OUT $binding"
		else
			if python -c "import gnome$binding" 2> /dev/null; then
				BINDINGS_OUT="$BINDINGS_OUT gnome$binding"
			else
				BINDINGS_OUT="$BINDINGS_OUT $(echo $binding | cut -f2 -d_)"
			fi
		fi
	done

	echo "$CAT/$PN: $BINDINGS_OUT" | tr -s ' ' >> $TMP
done

cat $TMP |sort -u

rm $TMP
