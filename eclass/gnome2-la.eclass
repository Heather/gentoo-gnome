# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# gnome2-la.eclass
#
# Original Author: Nirbheek Chauhan <nirbheek@gentoo.org>
# Purpose: Temporary eclass for facilitating .la file removal
#
# Only for usage in the overlay. This eclass will be redundant once this feature
# is reviewed and patched into gnome2.eclass (in-tree)
#

inherit gnome2

EXPORT_FUNCTIONS src_install

# Remove .la files in src_install?
G2PUNT_LA=${G2PUNT_LA:-"no"}

gnome2-la_src_install() {
	gnome2_src_install

	# Remove .la files if they're unneeded
	# Be *absolutely* sure before doing this and read
	# http://dev.gentoo.org/~nirbheek/gnome/gnome-policy.xml#doc_chap3
	if [[ "${G2PUNT_LA}" = "yes" ]]; then
		ebegin "Removing .la files"
		find "${D}" -name '*.la' -delete
		eend
	fi
}
