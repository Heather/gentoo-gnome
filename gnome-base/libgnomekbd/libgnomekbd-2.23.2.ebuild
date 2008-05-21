# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgnomekbd/libgnomekbd-2.22.0.ebuild,v 1.1 2008/03/23 02:58:58 leio Exp $

inherit gnome2

DESCRIPTION="Gnome keyboard configuration library"
HOMEPAGE="http://www.gnome.org"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-libs/glib-2.6
		 >=sys-apps/dbus-0.92
		 >=dev-libs/dbus-glib-0.34
		 >=gnome-base/gconf-2.14
		 >=x11-libs/gtk+-2.10.3
		 >=gnome-base/libglade-2.6
		 >=gnome-base/libgnome-2.16
		 >=gnome-base/libgnomeui-2.16
		 >=x11-libs/libxklavier-3.2
		 !<gnome-base/control-center-2.17.0"
DEPEND="${RDEPEND}
		>=dev-util/intltool-0.35
		>=dev-util/pkgconfig-0.19"

DOCS="AUTHORS ChangeLog NEWS README"

# This collides with
# /etc/gconf/schemas/desktop_gnome_peripherals_keyboard_xkb.schemas from
# <=control-center-2.17...

pkg_setup() {
	# Only user interaction required graphical tests at the time of 2.22.0 - not useful for us
	G2CONF="${G2CONF} --disable-tests"
}

src_compile() {
	# FreeBSD doesn't like -j
	use x86-fbsd && MAKEOPTS="${MAKEOPTS} -j1"
	gnome2_src_compile
}
