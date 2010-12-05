# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# gnome2-live.eclass
#
# Exports additional functions used by live ebuilds written for GNOME packages
# Always to be imported *AFTER* gnome2.eclass
#
# Author: Nirbheek Chauhan <nirbheek@gentoo.org>
#


inherit autotools gnome2 gnome2-utils libtool git

# Stolen from git.eclass
EXPORTED_FUNCTIONS="src_unpack pkg_postinst"
case "${EAPI:-0}" in
    2|3) EXPORTED_FUNCTIONS="${EXPORTED_FUNCTIONS} src_prepare" ;;
    0|1) ;;
    *) die "Unknown EAPI, Bug eclass maintainers." ;;
esac
EXPORT_FUNCTIONS ${EXPORTED_FUNCTIONS}

# DEPEND on
# app-text/gnome-doc-utils for gnome-doc-*
# dev-util/gtk-doc for gtkdocize
# dev-util/intltool for intltoolize
# gnome-base/gnome-common for GNOME_COMMON_INIT
DEPEND="${DEPEND}
	gnome-base/gnome-common
	app-text/gnome-doc-utils
	dev-util/gtk-doc
	dev-util/intltool"

# Extra options passed to elibtoolize
ELTCONF=${ELTCONF:-}

# Default module svn path
MODPATH=${MODPATH:-"${PN}"}

# GIT URI for the project
EGIT_REPO_URI="${EGIT_REPO_URI:-"git://git.gnome.org/${MODPATH}"}"

# Unset SRC_URI auto-set by gnome2.eclass
SRC_URI=""

gnome2-live_src_unpack() {
	if test -n "${A}"; then
		unpack ${A}
	fi
	git_src_unpack
	has src_prepare ${EXPORTED_FUNCTIONS} || gnome2-live_src_prepare
}

gnome2-live_src_prepare() {
	# Blame git.eclass
	cd "${S}"
	for i in ${PATCHES}; do
		epatch "${i}"
	done

	# Find and create macro dirs
	macro_dirs=($(sed -ne 's/AC_CONFIG_MACRO_DIR(\(.*\))/\1/p' configure.* | tr -d '[]'))
	for i in "${macro_dirs[@]}"; do
		mkdir -p "$i"
	done

	if grep -qe 'GTK_DOC' configure.*; then
		gtkdocize
	fi
	if grep -qe 'GNOME_DOC_INIT' configure.*; then
		gnome-doc-common
		gnome-doc-prepare --automake
	fi
	if grep -qe "IT_PROG_INTLTOOL" -e "AC_PROG_INTLTOOL" configure.*; then
		if grep -qe "AC_PROG_INTLTOOL" configure.*; then
			eqawarn "This package is using deprecated AC_PROG_INTLTOOL macro."
			eqawarn "Please fill a bug to the upstream of this package."
		fi
		intltoolize --force
	fi
	if test -e m4; then
		AT_M4DIR=m4 eautoreconf
	else
		eautoreconf
	fi

	# Disable pyc compiling. Doesn't harm if DNE
	ln -sf $(type -P true) py-compile

	### Keep this in-sync with gnome2.eclass!
	# Prevent scrollkeeper access violations
	gnome2_omf_fix

	# Libtool patching
	elibtoolize ${ELTCONF}
}

# So that it replaces gnome2_src_unpack in ebuilds that call it
gnome2_src_unpack() {
	gnome2-live_src_unpack
}

# So that it replaces gnome2_src_prepare in ebuilds that call it
gnome2_src_prepare() {
	gnome2-live_src_prepare
}

# Run manually for ebuilds that have a custom pkg_postinst
gnome2-live_pkg_postinst() {
	ewarn "This is a live ebuild, upstream trunks will mostly be UNstable"
	ewarn "Do NOT report bugs about this package to Gentoo"
	ewarn "Report upstream bugs (with patches if possible) instead."
}
