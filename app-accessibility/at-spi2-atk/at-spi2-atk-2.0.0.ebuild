# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="Gtk module for bridging AT-SPI to Atk"
HOMEPAGE="http://live.gnome.org/Accessibility"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=app-accessibility/at-spi2-core-1.91.92
	>=dev-libs/atk-1.29.3
	dev-libs/glib:2
	>=sys-apps/dbus-1
	x11-libs/libX11
"
DEPEND="${DEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.40
"
RDEPEND="${RDEPEND}
	!<gnome-extra/at-spi-1.32.0-r1"

pkg_setup() {
	DOCS="AUTHORS NEWS README"
	# xevie is deprecated/broken since xorg-1.6/1.7
	G2CONF="${G2CONF} --enable-p2p"
}
