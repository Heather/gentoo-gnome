# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Storage daemon that implements well defined DBus interfaces."
HOMEPAGE="http://www.freedesktop.org/wiki/Software/udisks"
SRC_URI="http://hal.freedesktop.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

# Okay, we need lvm2-2.02.61 (Release 15 Feb 2010) to actually get 
# lvm2 support in udisks.
# parted[device-mapper] causes device-mapper to be installed, and udev blocks on
# that, so we pull in lvm2 which provides device-mapper, and disable lvm2
# support.

RDEPEND=">=sys-fs/udev-147[extras]
	sys-apps/sg3_utils
	>=dev-libs/glib-2.15
	>=sys-apps/dbus-1.0
	>=dev-libs/dbus-glib-0.82
	>=sys-auth/polkit-0.92
	sys-apps/parted[-device-mapper]
	sys-fs/lvm2
	>=dev-libs/libatasmart-0.14"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	>=dev-util/pkgconfig-0.20
	>=dev-util/intltool-0.36"

src_configure() {
	econf --disable-lvm2 \
		--localstatedir=/var
}

src_install() {
	emake DESTDIR="${D}" install
	keepdir /var/{lib,run}/udisks
}
