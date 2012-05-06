# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GNOME2_LA_PUNT="yes"

inherit gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Library for handling and rendering XPS documents"
HOMEPAGE="http://live.gnome.org/libgxps"

LICENSE="LGPL-2.1"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi
IUSE="debug doc +introspection jpeg static-libs tiff"

RDEPEND=">=app-arch/libarchive-2.8
	>=dev-libs/glib-2.24:2
	media-libs/freetype:2
	>=x11-libs/cairo-1.10
	introspection? ( >=dev-libs/gobject-introspection-0.10.1 )
	jpeg? ( virtual/jpeg )
	tiff? ( media-libs/tiff[zlib] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		app-text/docbook-xml-dtd:4.1.2
		>=dev-util/gtk-doc-1.14 )"

# There is no automatic test suite, only an interactive test application
RESTRICT="test"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-test
		$(use_enable debug)
		$(use_enable introspection)
		$(use_with jpeg libjpeg)
		$(use_enable static-libs static)
		$(use_with tiff libtiff)"
	DOCS="AUTHORS ChangeLog NEWS README TODO"
}
