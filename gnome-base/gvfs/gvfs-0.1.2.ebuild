# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="GNOME Virtual Filesystem Layer"
HOMEPAGE="http://www.gnome.org"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cdda doc fuse samba"

# dang remove gio-standalone before putting in portage
RDEPEND="${DEPEND}
	>=dev-libs/glib-2.15.2
	sys-apps/dbus
	>=sys-apps/hal-0.5.9
	>=net-libs/libsoup-2.2.104
	cdda? ( >=dev-libs/libcdio-0.78.2 )
	fuse? ( sys-fs/fuse )
	samba? ( >=net-fs/samba-3 )"
DEPEND="
	dev-util/pkgconfig
	sys-devel/gettext
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="--enable-hal
		$(use_enable doc gtk-doc)
		$(use_enable cdda)
		$(use_enable fuse)
		$(use_enable samba)"
}
