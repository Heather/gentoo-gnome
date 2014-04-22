/^inherit/ {
	s/gnome2-live//
	s/gnome2/gnome3/
	s/  //g
}

s/gnome2_((src|pkg)_[^ ]*)/gnome3_\1/g

/^\t*DOCS="[^"]*"/ {
	s/ /" "/g
	s/="/=( "/
	s/"$/" )/
}

s/^GNOME2_LA_PUNT="no"/AUTOTOOLS_PRUNE_LIBTOOL_FILES="none"/
s/^GNOME2_LA_PUNT="yes"/AUTOTOOLS_PRUNE_LIBTOOL_FILES="modules"/
/^GNOME2_LA_PUNT=".*"/d
