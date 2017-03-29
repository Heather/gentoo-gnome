# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit gnome2

DESCRIPTION="Gnome flashback"
HOMEPAGE="https://git.gnome.org/browse/gnome-session"

LICENSE="GPL-2 LGPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

COMMON_DEPEND="
	>=dev-libs/glib-2.46.0:2[dbus]
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.18.0:3
	>=dev-libs/json-glib-0.10
	>=gnome-base/gnome-desktop-3.18:3
	>=gnome-base/gnome-session-3.24.0
	x11-wm/metacity
	gnome-base/gnome-panel
	gnome-base/gnome-applets
	net-wireless/gnome-bluetooth
"

RDEPEND="${COMMON_DEPEND}
	gnome-base/gnome-settings-daemon
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure
}

src_install() {
	gnome2_src_install
}

pkg_postinst() {
	gnome2_pkg_postinst
}
