# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2:2.5"

inherit base python

DESCRIPTION="Telepathy Logger is a session daemon that should be activated whenever telepathy is being used (similar to mission control lifetime)."
HOMEPAGE="http://telepathy.freedesktop.org/wiki/Logger"
SRC_URI="http://telepathy.freedesktop.org/releases/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"

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
	test? ( dev-python/twisted )
"

# FIXME: does not pass yet
RESTRICT="test"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	python_set_active_version 2
}

src_configure() {
	econf \
		$(use_enable doc gtk-doc) \
		--enable-debug \
		--enable-public-extensions \
		--disable-coding-style-checks \
		--disable-Werror \
		--disable-static
}

src_install() {
	base_src_install
	find "${ED}" -name "*.la" -delete || die "la files removal failed"
}
