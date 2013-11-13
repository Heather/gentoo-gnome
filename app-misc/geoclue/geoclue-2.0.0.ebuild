# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit gnome2 user

DESCRIPTION="A geoinformation D-Bus service"
HOMEPAGE="http://freedesktop.org/wiki/Software/GeoClue"
SRC_URI="http://www.freedesktop.org/software/${PN}/releases/2.0/${P}.tar.xz"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
IUSE="debug demo server"

RDEPEND=">=dev-libs/dbus-glib-0.100
	>=dev-libs/glib-2.34.0
	dev-libs/libxml2
	server? ( >=dev-libs/geoip-1.5.1 )
	demo? ( x11-libs/libnotify )
	>=dev-libs/json-glib-0.14
	net-libs/libsoup:2.4
	sys-apps/dbus
	!<sci-geosciences/geocode-glib-3.10.0"
DEPEND="${RDEPEND}
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.40
	virtual/pkgconfig"

pkg_setup() {
	enewgroup geoclue
	enewuser geoclue -1 -1 -1 geoclue
}

src_configure() {
	gnome2_src_configure \
		--with-dbus-service-user=geoclue \
		$(use_enable server geoip-server) \
		$(use_enable debug) \
		$(use_enable demo demo-agent)
}
