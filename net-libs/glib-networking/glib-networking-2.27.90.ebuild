# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit gnome2

DESCRIPTION="Network-related giomodules for glib"
HOMEPAGE="http://git.gnome.org/browse/glib-networking/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+gnutls +libproxy"

RDEPEND=">=dev-libs/glib-2.27.90
	gnutls? ( >=net-libs/gnutls-2.1.7 )
	libproxy? ( >=net-libs/libproxy-0.3.1 )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35.0
	>=dev-util/pkgconfig-0.9
	sys-devel/gettext"

pkg_setup() {
	# AUTHORS, ChangeLog are empty
	DOCS="NEWS README"
	G2CONF="${G2CONF}
		--disable-static
		--disable-maintainer-mode
		--with-ca-certificates=${ROOT}/etc/ssl/certs/ca-certificates.crt
		$(use_with gnutls)
		$(use_with libproxy)"
}
