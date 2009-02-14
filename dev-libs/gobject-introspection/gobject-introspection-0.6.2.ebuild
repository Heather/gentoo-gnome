# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools gnome2 eutils

DESCRIPTION="The GObject introspection"
HOMEPAGE="http://live.gnome.org/GObjectIntrospection/"

LICENSE="LGPL-2 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.19.0
	|| (
		sys-devel/gcc[libffi]
		virtual/libffi )
	>=dev-lang/python-2.5"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.18
	sys-devel/flex"

G2CONF="${G2CONF} --disable-static"

src_prepare() {
	gnome2_src_prepare

	# Fix build failure
	epatch "${FILESDIR}/${P}-gir.patch"

	eautomake
}

