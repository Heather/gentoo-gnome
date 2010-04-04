# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit bash-completion gnome2

DESCRIPTION="Storage daemon that implements well defined DBus interfaces."
HOMEPAGE="http://www.freedesktop.org/wiki/Software/udisks"
SRC_URI="http://hal.freedesktop.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="bash-completion lvm2 remote-access"

COMMON_DEPEND="
	>=dev-libs/glib-2.16.1
	>=sys-apps/dbus-1.0
	>=dev-libs/dbus-glib-0.82
	>=sys-auth/polkit-0.92

	>=dev-libs/libatasmart-0.14
	>=sys-apps/sg3_utils-1.27.20090411
	>=sys-apps/parted-1.8.8[device-mapper]
	>=sys-fs/lvm2-2.02.48-r2
	>=sys-fs/udev-147[extras]
	lvm2? ( >=sys-fs/lvm2-2.02.61 )"
RDEPEND="${COMMON_DEPEND}
	remote-access? ( net-dns/avahi )"
DEPEND="${COMMON_DEPEND}
	dev-libs/libxslt
	>=dev-util/pkgconfig-0.20
	>=dev-util/intltool-0.40
	doc? ( >=dev-util/gtk-doc-1.3 )"
# dev-util/gtk-doc-am needed if eautoreconf

pkg_setup() {
	# Pedantic is currently broken
	G2CONF="${G2CONF}
		--disable-ansi
		--enable-man-pages
		--localstatedir=/var
		$(use_enable lvm2)
		$(use_enable remote-access)"
}

src_prepare() {
	gnome2_src_prepare

	# Fix intltoolize broken file, see upstream #577133
	sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in || die "sed failed"
}

src_install() {
	gnome2_src_install

	if use bash-completion; then
		dobashcompletion "${S}/tools/udisks-bash-completion.sh"
	fi
}
