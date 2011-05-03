# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2 gnome2-live

DESCRIPTION="JavaScript Extensions for GNOME Shell"
HOMEPAGE="http://live.gnome.org/GnomeShell/Extensions"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	EGIT_TREE="3.0.1"
	EGIT_BRANCH="gnome-3-0"
	KEYWORDS="~amd64 ~x86"
fi

COMMON_DEPEND="
	>=dev-libs/glib-2.26
	>=gnome-base/gnome-desktop-2.91.6:3"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gnome-desktop:3[introspection]
	media-libs/clutter:1.0[introspection]
	net-libs/telepathy-glib[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/pango[introspection]"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.22
	>=dev-util/intltool-0.26
	gnome-base/gnome-common"

pkg_setup() {
	DOCS="HACKING README"
	G2CONF="${G2CONF}
		--enable-extensions=all
		--disable-schemas-compile"
}
