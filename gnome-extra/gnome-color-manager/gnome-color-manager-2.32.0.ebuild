# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Gnome Color Manager"
HOMEPAGE="http://projects.gnome.org/gnome-color-manager/"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

RDEPEND=">=dev-libs/glib-2.14:2
	>=dev-libs/dbus-glib-0.73
	>=dev-libs/libunique-1
	>=gnome-base/gconf-2
	>=gnome-base/gnome-desktop-2.14
	media-gfx/sane-backends
	media-libs/lcms
	media-libs/libcanberra[gtk]
	media-libs/tiff
	net-print/cups
	sys-fs/udev[extras]
	x11-libs/libX11
	x11-libs/libXxf86vm
	x11-libs/libXrandr
	>=x11-libs/gtk+-2.14:2
	x11-libs/libnotify
	>=x11-libs/vte-0.22
"
DEPEND="${RDEPEND}
	app-text/gnome-doc-utils
	>=dev-util/intltool-0.35
	doc? ( >=dev-util/gtk-doc-1.9 )
"

# FIXME: run test-suite with files on live file-system
RESTRICT="test"

pkg_setup() {
	G2CONF="${G2CONF} $(use_enable test tests)"
}
