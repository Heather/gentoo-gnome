# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2 virtualx
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Helper library for RESTful services"
HOMEPAGE="http://live.gnome.org/Librest"

LICENSE="LGPL-2.1"
SLOT="0.7"
IUSE="+gnome +introspection test"
if [[ ${PV} = 9999 ]]; then
	IUSE="${IUSE} doc"
	KEYWORDS=""
else
	KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86"
fi

# Coverage testing should not be enabled
RDEPEND="app-misc/ca-certificates
	>=dev-libs/glib-2.24:2
	dev-libs/libxml2:2
	net-libs/libsoup:2.4
	gnome? ( >=net-libs/libsoup-gnome-2.25.1:2.4 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.13
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	test? ( sys-apps/dbus )
"

if [[ ${PV} = 9999 ]]; then
	DEPEND="${DEPEND}
		doc? ( >=dev-util/gtk-doc-1.13 )"
fi

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--disable-gcov \
		--with-ca-certificates="${EPREFIX}"/etc/ssl/certs/ca-certificates.crt \
		$(use_with gnome) \
		$(use_enable introspection)
}

src_test() {
	# Tests need dbus
	Xemake check || die
}
