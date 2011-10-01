# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"

inherit gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="GNOME contact management application"
HOMEPAGE="https://live.gnome.org/Design/Apps/Contacts"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi

RDEPEND=">=dev-libs/folks-0.6.1.1
	>=dev-libs/glib-2.29.12:2
	dev-libs/libgee:0
	>=gnome-extra/evolution-data-server-3[gnome-online-accounts]
	>=gnome-base/gnome-desktop-3.0:3
	net-libs/gnome-online-accounts
	net-libs/telepathy-glib
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.0:3
	x11-libs/libnotify
	x11-libs/pango"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17"

if [[ ${PV} = 9999 ]]; then
	DEPEND="${DEPEND}
		>=dev-lang/vala-0.14.0:0.14
		net-libs/telepathy-glib[vala]"
fi

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS" # README is empty
	# configure checks for valac, but will not use it when building from tarball
	if [[ ${PV} = 9999 ]]; then
		G2CONF="${G2CONF} VALAC=$(type -p valac-0.14)"
	fi
}
