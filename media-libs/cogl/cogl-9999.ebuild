# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
CLUTTER_LA_PUNT="yes"

# Inherit gnome2 after clutter to download sources from gnome.org
# since clutter-project.org doesn't provide .xz tarballs
inherit clutter gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="A library for using 3D graphics hardware to draw pretty pictures"
HOMEPAGE="http://www.clutter-project.org/"

LICENSE="LGPL-2.1"
SLOT="1.0"
IUSE="doc examples +introspection +pango"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi

# XXX: need uprof for optional profiling support
COMMON_DEPEND=">=dev-libs/glib-2.26.0:2
	x11-libs/cairo
	>=x11-libs/gdk-pixbuf-2:2
	x11-libs/libdrm
	x11-libs/libX11
	>=x11-libs/libXcomposite-0.4
	x11-libs/libXdamage
	x11-libs/libXext
	>=x11-libs/libXfixes-3
	virtual/opengl

	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
	pango? ( >=x11-libs/pango-1.20.0[introspection?] )"
# before clutter-1.7, cogl was part of clutter
RDEPEND="${COMMON_DEPEND}
	!!<media-libs/clutter-1.7"
DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig
	sys-devel/gettext
	doc? ( app-text/docbook-xml-dtd:4.1.2
		>=dev-util/gtk-doc-1.13 )"

pkg_setup() {
	DOCS="NEWS README"
	EXAMPLES="examples/*.c"
	# XXX: think about gles, quartz, wayland
	# --with-pic needed due to https://bugzilla.gnome.org/show_bug.cgi?id=653615
	G2CONF="${G2CONF}
		--with-pic=both
		--disable-profile
		--disable-maintainer-flags
		--enable-cairo
		--enable-gdk-pixbuf
		--enable-gl
		--enable-glx
		$(use_enable introspection)
		$(use_enable pango cogl-pango)"
}

src_install() {
	clutter_src_install
}
