# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gucharmap/gucharmap-2.26.3.1.ebuild,v 1.1 2009/07/16 23:30:57 eva Exp $

inherit gnome2 gnome2-la

DESCRIPTION="Unicode character map viewer"
HOMEPAGE="http://gucharmap.sourceforge.net/"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="cjk doc gnome python test"

# FIXME: add gobject-introspection support once available
RDEPEND=">=dev-libs/glib-2.16.3
	>=x11-libs/pango-1.2.1
	>=x11-libs/gtk+-2.13.6
	gnome? ( gnome-base/gconf )
	python? ( >=dev-python/pygtk-2.7.1 )"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.40
	>=app-text/gnome-doc-utils-0.9.0
	doc? ( >=dev-util/gtk-doc-1.0 )
	test? ( ~app-text/docbook-xml-dtd-4.1.2 )"

DOCS="ChangeLog NEWS README TODO"

pkg_setup() {
	G2PUNT_LA="yes"
	G2CONF="${G2CONF}
		--disable-scrollkeeper
		--disable-maintainer-mode
		$(use_enable gnome gconf)
		$(use_enable cjk unihan)
		$(use_enable python python-bindings)"
}
