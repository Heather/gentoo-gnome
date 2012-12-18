# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python2_{5,6,7} )

inherit gnome2 distutils-r1

DESCRIPTION="Clocks applications for GNOME"
HOMEPAGE="http://live.gnome.org/GnomeClocks"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/libgweather[introspection]
	dev-python/pycairo
	dev-python/pygobject:3
	dev-python/pyxdg
	media-libs/clutter-gtk:1.0[introspection]
	media-libs/clutter:1.0[introspection]
	x11-libs/gdk-pixbuf:2[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/libnotify[introspection]
	x11-libs/pango[introspection]
"
DEPEND="${RDEPEND}
	dev-python/python-distutils-extra
"
