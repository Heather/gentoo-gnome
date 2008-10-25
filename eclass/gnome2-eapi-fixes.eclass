# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# gnome2-eapi-fixes.eclass
#
# EAPI-specific fixes for gnome2.eclass
#
# Maintained by Nirbheek Chauhan <nirbheek.chauhan@gmail.com>
#

case "${EAPI}" in
	"2")
		# src_configure gets called twice (#239123)
		gnome2_src_compile() {
			default_src_compile
		}

		gnome2-eapi-fixes_src_compile() {
			gnome2_src_compile
		}

		EXPORT_FUNCTIONS src_compile
		;;
	*) :;;
esac
