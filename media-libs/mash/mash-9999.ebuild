# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
CLUTTER_LA_PUNT="yes"

# Inherit clutter after gnome2 to download sources from clutter-project.org
inherit autotools eutils gnome2 clutter
if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="git://github.com/clutter-project/mash.git"
	inherit gnome2-live
fi

DESCRIPTION="A library for rendering 3D models with Clutter"
HOMEPAGE="http://wiki.clutter-project.org/wiki/Mash"

LICENSE="LGPL-2.1"
SLOT="0.1"
IUSE="doc examples +introspection"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi

# Automagically detects x11-libs/mx, but only uses it for building examples
RDEPEND=">=dev-libs/glib-2.16:2
	>=media-libs/clutter-1.5.10:1.0[introspection?]
	media-libs/rply
	virtual/opengl

	introspection? ( >=dev-libs/gobject-introspection-0.6.1 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.14 )"

pkg_setup() {
	DOCS="AUTHORS NEWS README"
	EXAMPLES="example/{*.c,*.css,*.ply}"
	G2CONF="${G2CONF}
		--disable-static
		$(use_enable introspection)"
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.1.0-system-rply.patch"
	[[ ${PV} = 9999 ]] || eautoreconf
	gnome2_src_prepare
}

src_install() {
	clutter_src_install
}
