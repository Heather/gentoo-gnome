# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-utils/gnome-utils-2.24.1.ebuild,v 1.3 2009/01/12 20:25:34 armin76 Exp $

inherit gnome2

DESCRIPTION="Utilities for the Gnome2 desktop"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc hal ipv6 zlib"

RDEPEND=">=dev-libs/glib-2.16.0
	>=x11-libs/gtk+-2.13
	>=gnome-base/gnome-desktop-2.9.91
	>=gnome-base/libgnome-2.13.2
	>=gnome-base/libgnomeui-2.13.7
	>=gnome-base/libglade-2.3
	>=gnome-base/gnome-vfs-2.8.4
	>=gnome-base/gnome-panel-2.13.4
	>=gnome-base/libgtop-2.12
	>=gnome-base/gconf-2
	sys-fs/e2fsprogs
	hal? ( >=sys-apps/hal-0.5 )
	x11-libs/libXext"

DEPEND="${RDEPEND}
	x11-proto/xextproto
	app-text/gnome-doc-utils
	app-text/scrollkeeper
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.9
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS README THANKS"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable ipv6)
		$(use_enable hal)
		$(use_enable hal gfloppy)
		$(use_enable zlib)
		--enable-console-helper=no
		--disable-schemas-install
		--disable-scrollkeeper"
}
