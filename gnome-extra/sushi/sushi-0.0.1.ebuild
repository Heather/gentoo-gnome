# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="Quick previewer for the GNOME desktop file manager"
HOMEPAGE="http://www.gnome.org"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# Optional app-office/unoconv support
RDEPEND="
	>=dev-libs/gjs-0.7.7
	>=dev-libs/glib-2.28:2
	>=dev-libs/gobject-introspection-0.9.6
	>=media-libs/clutter-1.6:1.0
	>=media-libs/clutter-gtk-0.91.8:1.0
	media-libs/gstreamer:0.10
	media-libs/musicbrainz:3
	>=app-text/evince-3
	>=x11-libs/gdk-pixbuf-2.22.1:2
	>=x11-libs/gtk+-3:3
"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.22
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17
"
RDEPEND=">=gnome-base/nautilus-3"

pkg_setup() {
	DOCS="AUTHORS NEWS README TODO"
	G2CONF="${G2CONF} UNOCONV=$(type -p false)"
}
