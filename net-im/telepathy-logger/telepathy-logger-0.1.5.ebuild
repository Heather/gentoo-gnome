# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit base

DESCRIPTION="Telepathy Logger is a session daemon that should be activated whenever telepathy is being used (similar to mission control lifetime)."
HOMEPAGE="http://telepathy.freedesktop.org/wiki/Logger"
SRC_URI="http://telepathy.freedesktop.org/releases/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug doc test"

RDEPEND=">=dev-libs/glib-2.25.11:2
	>=sys-apps/dbus-1.1
	>=dev-libs/dbus-glib-0.82
	>=net-libs/telepathy-glib-0.11.7
	dev-libs/libxml2
	dev-libs/libxslt
	dev-db/sqlite:3
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	doc? ( >=dev-util/gtk-doc-1.10 )
	test? (
		>=dev-lang/python-2.5
		dev-python/twisted )
"

# FIXME: does not pass yet
RESTRICT="test"

DOCS="AUTHORS ChangeLog NEWS README"

src_configure() {
	econf \
		$(use_enable doc gtk-doc) \
		$(use_enable debug) \
		--enable-public-extensions \
		--disable-coding-style-checks \
		--disable-Werror \
		--disable-static
}

src_install() {
	base_src_install
	find "${ED}" -name "*.la" -delete || die "la files removal failed"
}
