# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

DESCRIPTION="PolicyKit helper to configure cups with fine-grained privileges"
HOMEPAGE="http://cgit.freedesktop.org/cups-pk-helper/"
SRC_URI="http://www.freedesktop.org/software/${PN}/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Require {glib,gdbus-codegen}-2.30.0 due to GDBus changes between 2.29.92
# and 2.30.0
COMMON_DEPEND=">=dev-libs/glib-2.30.0:2
	net-print/cups
	>=sys-auth/polkit-0.97"
RDEPEND="${COMMON_DEPEND}
	sys-apps/dbus"
DEPEND="${COMMON_DEPEND}
	>=dev-util/gdbus-codegen-2.30.0
	>=dev-util/intltool-0.40.6
	dev-util/pkgconfig
	sys-devel/gettext"

src_prepare() {
	DOCS="AUTHORS HACKING NEWS README"
}
