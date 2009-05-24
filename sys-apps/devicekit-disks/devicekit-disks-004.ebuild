# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit gnome2

MY_PN="DeviceKit-disks"

DESCRIPTION="D-Bus abstraction for enumerating power devices and querying history and statistics"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/DeviceKit"
SRC_URI="http://hal.freedesktop.org/releases/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc"

RDEPEND=">=dev-libs/glib-2.16.1
	>=dev-libs/dbus-glib-0.76
	>=sys-apps/dbus-1.0
	>=sys-auth/policykit-0.7
	>=sys-apps/devicekit-002
	>=sys-fs/udev-139
	|| (
		>=sys-fs/lvm2-2.02
		>=sys-fs/device-mapper-1.02 )
	>=sys-apps/parted-1.8.8[device-mapper]
	>=sys-apps/libatasmart-0.5

	dev-db/sqlite:3"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	dev-util/pkgconfig
	dev-libs/libxslt
	doc? ( >=dev-util/gtk-doc-1.3 )"
# dev-util/gtk-doc-am needed if eautoreconf

S="${WORKDIR}/${MY_PN}-${PV}"

pkg_setup() {
	# Pedantic is currently broken
	G2CONF="${G2CONF}
		--localstatedir=/var
		--disable-ansi
		--enable-man-pages
		$(use_enable debug verbose-mode)"
}

src_configure() {
	# No damned pkgconfig file :|
	DEVMAPPER_CFLAGS="-I/usr/include" DEVMAPPER_LIBS="-ldevmapper" \
		gnome2_src_configure
}
