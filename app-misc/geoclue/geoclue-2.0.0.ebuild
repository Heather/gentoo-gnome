# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit autotools eutils

DESCRIPTION="A geoinformation D-Bus service"
HOMEPAGE="http://freedesktop.org/wiki/Software/GeoClue"
SRC_URI="http://www.freedesktop.org/software/${PN}/releases/2.0/${P}.tar.xz"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
IUSE="connman geonames gps gsmloc gtk hostip manual networkmanager nominatim plazes skyhook static-libs yahoo-geo"

REQUIRED_USE="skyhook? ( networkmanager )"

RDEPEND=">=dev-libs/dbus-glib-0.100
	>=dev-libs/glib-2
	dev-libs/libxml2
	>=dev-libs/geoip-1.5.1
	>=dev-libs/json-glib-0.14
	net-libs/libsoup:2.4
	sys-apps/dbus
	gps? ( sci-geosciences/gpsd )
	gtk? ( x11-libs/gtk+:2 )
	networkmanager? ( net-misc/networkmanager )
	!<sci-geosciences/geocode-glib-3.10.0"
DEPEND="${RDEPEND}
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.40
	virtual/pkgconfig"

src_prepare() {
	sed -i -e '/CFLAGS/s:-g ::' configure.ac || die #399177
	sed -e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" -i configure.ac || die
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files
}
