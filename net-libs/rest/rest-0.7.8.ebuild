# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2 virtualx

DESCRIPTION="Helper library for RESTful services"
HOMEPAGE="http://git.gnome.org/browse/librest"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +gnome +introspection test"

# XXX: coverage testing should not be enabled
RDEPEND=">=dev-libs/glib-2.18:2
	dev-libs/libxml2:2

	gnome? ( >=net-libs/libsoup-gnome-2.25.1:2.4 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.13
	>=dev-util/intltool-0.40
	dev-util/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.13 )
	test? ( sys-apps/dbus )"

src_prepare() {
	G2CONF="${G2CONF}
		--disable-static
		--disable-gcov
		$(use_with gnome)
		$(use_enable introspection)"
	DOCS="AUTHORS NEWS README"
}

src_test() {
	# Tests need dbus
	Xemake check || die
}
