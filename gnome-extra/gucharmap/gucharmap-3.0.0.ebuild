# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gucharmap/gucharmap-2.32.1.ebuild,v 1.1 2010/11/19 21:53:00 pacho Exp $

EAPI="3"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="Unicode character map viewer"
HOMEPAGE="http://live.gnome.org/Gucharmap"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="cjk doc gnome +introspection test"

RDEPEND=">=dev-libs/glib-2.16.3
	>=x11-libs/pango-1.2.1
	>=x11-libs/gtk+-3.0.0:3

	gnome? ( gnome-base/gconf:2 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.0 )"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.40
	>=app-text/gnome-doc-utils-0.9.0

	sys-devel/gettext

	doc? ( >=dev-util/gtk-doc-1.0 )
	test? ( ~app-text/docbook-xml-dtd-4.1.2 )"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-static
		--disable-scrollkeeper
		--disable-maintainer-mode
		--with-gtk=3.0
		$(use_enable gnome gconf)
		$(use_enable introspection)
		$(use_enable cjk unihan)"
	DOCS="ChangeLog NEWS README TODO"
}
