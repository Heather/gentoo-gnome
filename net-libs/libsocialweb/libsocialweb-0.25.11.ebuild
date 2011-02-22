# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="Social web services integration framework"
HOMEPAGE="http://git.gnome.org/browse/libsocialweb"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc connman +gnome +networkmanager"

# XXX: coverage testing should not be enabled
RDEPEND=">=dev-libs/glib-2.14:2
	>=net-libs/rest-0.7.1

	gnome-base/gconf:2
	gnome-base/libgnome-keyring
	dev-libs/dbus-glib
	dev-libs/json-glib
	
	gnome? ( >=net-libs/libsoup-gnome-2.25.1:2.4 )
	networkmanager? ( net-misc/networkmanager )
	!networkmanager? ( connman? ( net-misc/connman ) )"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.15
	>=dev-util/intltool-0.40
	dev-util/pkgconfig
	sys-devel/gettext
	doc? (
		dev-libs/libxslt
		>=dev-util/gtk-doc-1.15 )"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-static
		--disable-gcov
		--enable-all-services
		$(use_with gnome)
		--with-online=always"

	# NetworkManager always overrides connman support
	use connman && G2CONF="${G2CONF} --with-online=connman"
	use networkmanager && G2CONF="${G2CONF} --with-online=networkmanager"
	DOCS="AUTHORS README TODO"
}
