# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="A photos application for GNOME"
HOMEPAGE="https://live.gnome.org/Design/Apps/Photos"

LICENSE="GPL-2+ LGPL-2+ MIT CC-BY-3.0 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="
	media-libs/babl
	x11-libs/cairo[glib]
	>=media-libs/exempi-1.99.5
	>=media-libs/gegl-0.2
	>=x11-libs/gdk-pixbuf-2.0
	>=dev-libs/glib-2.35.1:2
	>=gnome-base/gnome-desktop-3.0
	>=net-libs/gnome-online-accounts-3.8.0
	>=media-libs/grilo-0.2.6:0.2
	>=x11-libs/gtk+-3.9.11:3[cups]
	media-libs/lcms:2
	>=media-libs/libexif-0.6.14
	>=gnome-base/librsvg-2.26.0
	>=app-misc/tracker-0.16
"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.50.1
	virtual/pkgconfig
"
