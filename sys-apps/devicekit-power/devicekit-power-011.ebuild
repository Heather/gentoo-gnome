# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit gnome2 linux-info

MY_PN="DeviceKit-power"

DESCRIPTION="D-Bus abstraction for enumerating power devices and querying history and statistics"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/DeviceKit"
SRC_URI="http://hal.freedesktop.org/releases/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc test"

RDEPEND=">=dev-libs/glib-2.21.5
	>=dev-libs/dbus-glib-0.76
	>=sys-fs/udev-145[extras]
	>=sys-auth/polkit-0.91
	sys-apps/dbus
	virtual/libusb
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	dev-util/pkgconfig
	dev-libs/libxslt
	dev-util/gtk-doc-am
	doc? ( >=dev-util/gtk-doc-1.3 )
"

S="${WORKDIR}/${MY_PN}-${PV}"

function check_battery() {
	# check sysfs power interface, bug #263959
	local CONFIG_CHECK="ACPI_SYSFS_POWER"
	check_extra_config
}

pkg_setup() {
	# Pedantic is currently broken
	G2CONF="${G2CONF}
		--localstatedir=/var
		--disable-ansi
		--enable-man-pages
		$(use_enable debug verbose-mode)
		$(use_enable test tests)
	"

	check_battery
}

src_prepare() {
	gnome2_src_prepare

	# Fix crazy cflags
	sed 's:-DG.*DISABLE_DEPRECATED::g' -i configure.ac configure \
		|| die "sed failed"
}
