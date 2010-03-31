# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Playlist parsing library"
HOMEPAGE="http://www.gnome.org/projects/totem/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
# TODO: Re-generate doc ?
# TODO: Introspection
IUSE="doc test"

RDEPEND=">=dev-libs/glib-2.21.6
	dev-libs/gmime:2.4"
DEPEND="${RDEPEND}
	!<media-video/totem-2.21
	>=dev-util/intltool-0.35
	dev-util/gtk-doc-am
	doc? ( >=dev-util/gtk-doc-1.11 )"

DOCS="AUTHORS ChangeLog NEWS"
G2CONF="${G2CONF} --disable-introspection --disable-static"
# FIXME: testsuite does not work, please fix them and report on upstream
RESTRICT="test"

src_prepare() {
	gnome2_src_prepare

	# FIXME: tarball generated with broken gtk-doc, revisit me.
	if use doc; then
		sed "/^TARGET_DIR/i \GTKDOC_REBASE=/usr/bin/gtkdoc-rebase" \
			-i gtk-doc.make || die "sed 1 failed"
	else
		sed "/^TARGET_DIR/i \GTKDOC_REBASE=$(type -P true)" \
			-i gtk-doc.make || die "sed 2 failed"
	fi
}
