# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="A quick previewer for Nautilus, the GNOME file manager"
HOMEPAGE="http://git.gnome.org/browse/sushi"

LICENSE="GPL-3"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi
IUSE=""

# Optional app-office/unoconv support (OOo to pdf)
# freetype needed for font loader
# libX11 needed for sushi_create_foreign_window()
COMMON_DEPEND=">=x11-libs/gdk-pixbuf-2.22.1[introspection]
	>=dev-libs/gjs-0.7.7
	>=dev-libs/glib-2.29.14:2
	>=dev-libs/gobject-introspection-0.9.6
	>=media-libs/clutter-1.6.0:1.0[introspection]
	>=media-libs/clutter-gtk-1.0.1:1.0[introspection]
	>=x11-libs/gtk+-3.0.0:3[introspection]

	>=app-text/evince-3.0[introspection]
	media-libs/freetype:2
	media-libs/gstreamer:0.10[introspection]
	media-libs/gst-plugins-base:0.10[introspection]
	media-libs/clutter-gst:1.0[introspection]
	media-libs/musicbrainz:3
	net-libs/webkit-gtk:3[introspection]
	x11-libs/gtksourceview:3.0[introspection]
	x11-libs/libX11
"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.22
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17
"
RDEPEND="${COMMON_DEPEND}
	>=gnome-base/nautilus-3.1.90
"

pkg_setup() {
	G2CONF="${G2CONF}
		UNOCONV=$(type -p false)
		--disable-static
		--disable-maintainer-mode"
	DOCS="AUTHORS NEWS README TODO"
}
