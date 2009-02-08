# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

MY_PN="DeviceKit"

DESCRIPTION="D-Bus abstraction for enumerating devices and listening for device events using udev"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/DeviceKit"
SRC_URI="http://hal.freedesktop.org/releases/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

RDEPEND=">=dev-libs/glib-2.12
	>=dev-libs/dbus-glib-0.76
	>=sys-fs/udev-130
"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-libs/libxslt
	doc? ( >=dev-util/gtk-doc-1.3 )
"

S="${WORKDIR}/${MY_PN}-${PV}"

pkg_setup() {
	G2CONF="${G2CONF}
		--enable-ansi
		--enable-man-pages"
}
