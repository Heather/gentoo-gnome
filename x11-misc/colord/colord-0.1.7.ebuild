# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit base

DESCRIPTION="system service to accurately color manage input and output devices"
HOMEPAGE="http://colord.hughsie.com/"
SRC_URI="http://people.freedesktop.org/~hughsient/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# XXX: raise to libusb-1.0.9:1 when available
RDEPEND="
	dev-db/sqlite:3
	>=dev-libs/glib-2.25.9:2
	>=dev-libs/libusb-1.0.8:1
	media-gfx/sane-backends
	media-libs/lcms:2
	>=sys-auth/polkit-0.97
	sys-fs/udev[extras]
"
DEPEND="${RDEPEND}
	app-text/docbook-sgml-utils
	dev-libs/libxslt
	>=dev-util/intltool-0.35
	dev-util/pkgconfig
	sys-devel/gettext
"

# FIXME: needs pre-installed dbus service files
RESTRICT="test"

DOCS=(AUTHORS ChangeLog MAINTAINERS NEWS README TODO)

src_configure() {
	econf \
		--disable-examples \
		--disable-static \
		--enable-polkit \
		--enable-reverse \
		--enable-sane
}

src_install() {
	base_src_install
	find "${D}" -name "*.la" -delete
}
