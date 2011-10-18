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

DESCRIPTION="GNOME document manager"
HOMEPAGE="https://live.gnome.org/Design/Apps/Documents"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi

COMMON_DEPEND="
	>=app-misc/tracker-0.12.1
	>=app-text/evince-3[introspection]
	dev-libs/gjs
	>=dev-libs/glib-2.29.90:2
	>=dev-libs/gobject-introspection-0.9.6
	>=dev-libs/libgdata-0.9.1[introspection]
	gnome-base/gnome-desktop:3
	>=media-libs/clutter-gtk-1.0.1:1.0[introspection]
	>=net-libs/gnome-online-accounts-3.1.90
	net-libs/liboauth
	net-libs/libsoup:2.4
	x11-libs/gdk-pixbuf:2[introspection]
	>=x11-libs/gtk+-3.1.13:3[introspection]
	x11-libs/pango[introspection]"
RDEPEND="${COMMON_DEPEND}
	media-libs/clutter[introspection]
	sys-apps/dbus"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.22
	>=sys-devel/gettext-0.17"

pkg_setup() {
	DOCS="AUTHORS NEWS README TODO"
	G2CONF="${G2CONF} --disable-schemas-compile"
}
